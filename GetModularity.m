
function[Q  e a out_clusters] = GetModularity(adjacent_matrix,clusters)
uni = unique(clusters(3,:));%ÿ�κϲ�������ű�ţ�ͬһ���ŵı����ͬ,uni����һ������
for i=1:length(uni)
    idices = find(clusters(3,:) == uni(i));
    clusters(2,idices) = i;%��ͬһ�����ŵĽڵ㸳i.
end

m=sum(sum(adjacent_matrix))/2;%����ıߵ���Ŀ
Q = 0;
k= numel(unique(clusters(2,:)));% �ϲ����������Ŀ
e = zeros(k); %k*k����k��������Ŀ������Ԫ�صĶ���Ϊ��eij=1/2m(����ڵ�i��j֮���б�����) or eij=0��������
for i=1:k                 %���¼���e
    idx = find(clusters(2,:) == i);     %���ڵ�i�����Žڵ��
    labelsi = clusters(1,idx);
for j=1:k
    idx = find(clusters(2,:) == j);
    labelsj = clusters(1,idx);
    for  ii=1:length(labelsi)
        vi = labelsi(ii);
        for jj=1:length(labelsj)
            vj = labelsj(jj);
            e(i,j) = e(i,j) + adjacent_matrix(vi,vj);           %�����������ŵı���
            %Ԫ��eij����ʾ����������������ͬ���ŵĽ��ı������б���ռ�ı��������������ֱ�λ�ڵ�i�������͵�j�����š�
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
