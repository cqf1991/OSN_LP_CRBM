%%
clc
clear
R=importdata('C:\Users\XF-pc\Desktop\multislice network\MSNs data\INFOCOM06.txt');
testAUC=unique(R(:,1:2),'rows');
testAUC(:,3)=1;
testAUC=xishu2Adj(testAUC,R);
%R(:,3) = [];
%R(:,3) = [];
%R(:,3) = [];
%R(:,3) = [];
%net=FormNet(R);%书上例子
t_min=min(R(:,3));%最小初始时间
t_max=max(R(:,4));%最大结束时间 
t_max;
t_min;
m = t_max - t_min;%整个数据集节点通讯总时长
% 采样周期mit300  info 120s
s=m/180;%时间片slice（MIT数据下30天，每30分钟一片1800 for mit97）%infocom数据3天，3分钟一片(180 for infocom05)
%T = round((t_max - t_min)/s)
QS=[]; 
A = 0;%单片邻接矩阵
TLP=0;
AA=0; %test of A备用
A_wei = 0%单片邻接矩阵（时间因子加权）
a=0.995;% 时间片参数
lambda=0.001;%三阶路径系数（论文有这么区10e-3）
timeSlice=[];%时间片内，连接的个数

sampleMat={};%细胞数组，存储每个时间片的权值
sum_adj_mat={};
for i=1:round(s)
    clear xishu_mat;   
    TS=t_min;%时间片开始时间
    TE=t_min+(m/s);%时间片结束时间
    [xishu_mat]=xishu_mat(TS,TE,R);  %生成一片稀疏矩阵
   %% 归一化处理 (留在dbn之前做吧)
   
   
   %% 计算2个临街矩阵和权值矩阵
    timeSlice=length(xishu_mat); %获取最后一个时刻连接的个数
    Adj_Mat = xishu2Adj(xishu_mat,R); %临街矩阵
    Wei_Adj_Mat=xishu2Wei(xishu_mat,R);%TODO.临街权值矩阵
    sum_adj_mat{i}=Adj_Mat;%所有时刻的临街矩阵 用来确定label
    
    %% LNH-II
    %train=Adj_Mat;
    %M=nnz(train)/2;
    %D=sparse(eye(size(train,1)));
    %D(logical(D))=sum(train,2);
    %D=inv(D);
    %maxeig=max(eig(train));
    %tempmatrix=(sparse(eye(size(train,1)))-1/maxeig*train);
    %tempmatrix=inv(tempmatrix);
    %simLNH=2*M*maxeig*D*tempmatrix*D;
    

   %% RWR
   % deg=repmat(sum(Wei_Adj_Mat,2),[1,size(Wei_Adj_Mat,2)]);
   % Wei_Adj_Mat=Wei_Adj_Mat./deg;clear deg;
   % I=sparse(eye(size(Wei_Adj_Mat,1)));
   % simRWR=(1-0.5)*inv(I-0.5*Wei_Adj_Mat')*I;
   % simRWR=simRWR+simRWR';
    
   %% AA指标 
        %train1=Wei_Adj_Mat./repmat(log(sum(Adj_Mat,2)),[1,size(Adj_Mat,1)]);
        %train1(isnan(train1))=0;
        %train1(isinf(train1))=0;
        %sim=Wei_Adj_Mat*train1;%实现 ( AA+时间参数 )指标的计算
   %% LP(考虑123阶路径)
    sim=Wei_Adj_Mat*Wei_Adj_Mat;
    STLP=Wei_Adj_Mat+0.01*sim+0.01*0.01*(sim*sim*sim);%sim 是lp 指标的结果 bad% +wei_adj_mat用来考量当前节点对的继续发生链接的可能性
    %file2txt(xishu_mat,i);
    sampleMat{i}=STLP;
    AA=AA+Adj_Mat;%% AA表示用链接的个数来find L
    A= A + a^(s-i)*Wei_Adj_Mat;%临街权值矩阵  %!!!这里用STLP来确定比较好 若用临街矩阵会导致前后不符,用临街矩阵预测的边 不一定有CN
    TLP=TLP+STLP;
    %A_wei= A_wei + a^(s-i)*Wei_Adj_Mat%通过时间因子加权后的临街权值矩阵
    %save(['file_',num2str(i),'.mat'],'a','A'); %save file
    
    t_min=TE; 
end
%% 获取排序后的需要做dbn的数据集
[sorted]=findL(A,20); %A是矩阵，timeslice20表示最后时刻存在几条链接
%sorted 按照可能产生链接的节点对从高到底排序  一共是timeSlice20个 (先做20对)
sliceSize=200;%样本维度
%% 测试各个指标的AUC
%[train,test]=DivideNet(Adj_Mat,0.6);%mayuse adj_mat or testAuc/0.8
%lpAUC=LocalPath(train,test,lambda);
%stlpAUC=stLocalPath(STLP,train,test,lambda);
%cnAUC=CN(train,test);
%aaAUC=AA_AUC(train,test);
%kazeAUC=Katz(train,test,lambda);
%% 输出sample
sample=outPutSamples(sorted,sampleMat,sliceSize,sum_adj_mat);%用来做label 返回所有时间序列的前 timeslice对样本集合  timeslice*时间序列 的矩阵  ---并生成文件

plot(timeSlice,'oR');
%plotCDF(sample1,sample2,sample3);

