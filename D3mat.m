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
%net=FormNet(R);%��������
t_min=min(R(:,3));%��С��ʼʱ��
t_max=max(R(:,4));%������ʱ�� 
t_max;
t_min;
m = t_max - t_min;%�������ݼ��ڵ�ͨѶ��ʱ��
% ��������mit300  info 120s
s=m/180;%ʱ��Ƭslice��MIT������30�죬ÿ30����һƬ1800 for mit97��%infocom����3�죬3����һƬ(180 for infocom05)
%T = round((t_max - t_min)/s)
QS=[]; 
A = 0;%��Ƭ�ڽӾ���
TLP=0;
AA=0; %test of A����
A_wei = 0%��Ƭ�ڽӾ���ʱ�����Ӽ�Ȩ��
a=0.995;% ʱ��Ƭ����
lambda=0.001;%����·��ϵ������������ô��10e-3��
timeSlice=[];%ʱ��Ƭ�ڣ����ӵĸ���

sampleMat={};%ϸ�����飬�洢ÿ��ʱ��Ƭ��Ȩֵ
sum_adj_mat={};
for i=1:round(s)
    clear xishu_mat;   
    TS=t_min;%ʱ��Ƭ��ʼʱ��
    TE=t_min+(m/s);%ʱ��Ƭ����ʱ��
    [xishu_mat]=xishu_mat(TS,TE,R);  %����һƬϡ�����
   %% ��һ������ (����dbn֮ǰ����)
   
   
   %% ����2���ٽ־����Ȩֵ����
    timeSlice=length(xishu_mat); %��ȡ���һ��ʱ�����ӵĸ���
    Adj_Mat = xishu2Adj(xishu_mat,R); %�ٽ־���
    Wei_Adj_Mat=xishu2Wei(xishu_mat,R);%TODO.�ٽ�Ȩֵ����
    sum_adj_mat{i}=Adj_Mat;%����ʱ�̵��ٽ־��� ����ȷ��label
    
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
    
   %% AAָ�� 
        %train1=Wei_Adj_Mat./repmat(log(sum(Adj_Mat,2)),[1,size(Adj_Mat,1)]);
        %train1(isnan(train1))=0;
        %train1(isinf(train1))=0;
        %sim=Wei_Adj_Mat*train1;%ʵ�� ( AA+ʱ����� )ָ��ļ���
   %% LP(����123��·��)
    sim=Wei_Adj_Mat*Wei_Adj_Mat;
    STLP=Wei_Adj_Mat+0.01*sim+0.01*0.01*(sim*sim*sim);%sim ��lp ָ��Ľ�� bad% +wei_adj_mat����������ǰ�ڵ�Եļ����������ӵĿ�����
    %file2txt(xishu_mat,i);
    sampleMat{i}=STLP;
    AA=AA+Adj_Mat;%% AA��ʾ�����ӵĸ�����find L
    A= A + a^(s-i)*Wei_Adj_Mat;%�ٽ�Ȩֵ����  %!!!������STLP��ȷ���ȽϺ� �����ٽ־���ᵼ��ǰ�󲻷�,���ٽ־���Ԥ��ı� ��һ����CN
    TLP=TLP+STLP;
    %A_wei= A_wei + a^(s-i)*Wei_Adj_Mat%ͨ��ʱ�����Ӽ�Ȩ����ٽ�Ȩֵ����
    %save(['file_',num2str(i),'.mat'],'a','A'); %save file
    
    t_min=TE; 
end
%% ��ȡ��������Ҫ��dbn�����ݼ�
[sorted]=findL(A,20); %A�Ǿ���timeslice20��ʾ���ʱ�̴��ڼ�������
%sorted ���տ��ܲ������ӵĽڵ�ԴӸߵ�������  һ����timeSlice20�� (����20��)
sliceSize=200;%����ά��
%% ���Ը���ָ���AUC
%[train,test]=DivideNet(Adj_Mat,0.6);%mayuse adj_mat or testAuc/0.8
%lpAUC=LocalPath(train,test,lambda);
%stlpAUC=stLocalPath(STLP,train,test,lambda);
%cnAUC=CN(train,test);
%aaAUC=AA_AUC(train,test);
%kazeAUC=Katz(train,test,lambda);
%% ���sample
sample=outPutSamples(sorted,sampleMat,sliceSize,sum_adj_mat);%������label ��������ʱ�����е�ǰ timeslice����������  timeslice*ʱ������ �ľ���  ---�������ļ�

plot(timeSlice,'oR');
%plotCDF(sample1,sample2,sample3);
