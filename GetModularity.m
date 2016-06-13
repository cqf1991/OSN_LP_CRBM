
function[Q  e a out_clusters] = GetModularity(adjacent_matrix,clusters)
uni = unique(clusters(3,:));%每次合并后的社团编号，同一社团的编号相同,uni还是一个数组
for i=1:length(uni)
    idices = find(clusters(3,:) == uni(i));
    clusters(2,idices) = i;%把同一个社团的节点赋i.
end

m=sum(sum(adjacent_matrix))/2;%网络的边的数目
Q = 0;
k= numel(unique(clusters(2,:)));% 合并后的社团数目
e = zeros(k); %k*k矩阵，k是社团数目，其中元素的定义为：eij=1/2m(如果节点i和j之间有边相连) or eij=0（其他）
for i=1:k                 %重新计算e
    idx = find(clusters(2,:) == i);     %属于第i个社团节点号
    labelsi = clusters(1,idx);
for j=1:k
    idx = find(clusters(2,:) == j);
    labelsj = clusters(1,idx);
    for  ii=1:length(labelsi)
        vi = labelsi(ii);
        for jj=1:length(labelsj)
            vj = labelsj(jj);
            e(i,j) = e(i,j) + adjacent_matrix(vi,vj);           %连接两个社团的边数
            %元素eij，表示网络中连接两个不同社团的结点的边在所有边中占的比例；这两个结点分别位于第i个社区和第j个社团。
        end
    end
end
end

e = e/(2*m);
a = [];
for i=1:k
    ai = sum(e(i,:));
    a = [a ai];
    Q = Q + e(i,i)-ai^2;
end

out_clusters = clusters;
