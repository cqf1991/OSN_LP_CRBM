
function [Qlist] = FastNewman(adjacent_matrix)

% [u,v] = textread('F:\matlab_works\community_structure\data\Football.txt');
% u = u+1;
% v=v+1;
% m = length(u);
% A= zeros(max(u));
% for i=1:m
%     A(u(i),v(i)) = 1;
% end
% adjacent_matrix= A;
n=size(adjacent_matrix,1);%节点个数
max_id=n;
Qs = [];
clusters = [1:n; zeros(1,n); 1:n];%初始划分

while numel(unique(clusters(3,:))) ~=1
  [Q e a clusters] = GetModularity(adjacent_matrix, clusters);
  Qs = [Qs Q];
  k = size(e,1);
  DeltaQs = [];
  for i=1 : size(e,1)
      for j=1 :size(e,1)
          if(i~=j)
              DeltaQ = 2*(e(i,j)-a(i)*a(j));
              DeltaQs = [DeltaQs [i;j;DeltaQ]];%3行k^2列的矩阵
          end
      end
  end
[maxDeltaQ,id] = max(DeltaQs(3,:));id=id(1);
i = DeltaQs(1,id);j = DeltaQs(2,id);
max_id = max_id + 1;
c_id1 = find(clusters(2,:) == i);
c_id2 = find(clusters(2,:) == j);
clusters(3,c_id1) = max_id;
clusters(3,c_id2) = max_id;%要合并的两个节点

end

% x=1:length(Qs);
% y=Qs;
% plot(x,y,'b-');
% title(' Newman Fast Alg');
% xlabel('Merge Number');
% ylabel('Modularity');
%Plot(Qs)
Qlist = Qs;