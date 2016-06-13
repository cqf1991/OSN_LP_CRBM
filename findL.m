%%对权值临街矩阵A内元素进行排序，并且获得对应位置的
function [sorted] = findL(A,timeSlice)
    At=triu(A);%获取矩阵的上三角矩阵
    At=At+diag(-diag(At));%对角线元素赋值为0
    [a,b]=sort(At(:),'descend');%排序，b是对应的位置  降序
    sorted=[];%空矩阵
    n=1;
    for i=1:timeSlice
        if At(b(i))~=0
            [k,p]=find(At==At(b(i)))
            for t=1:length(k)        
                if isempty(sorted)
                    sorted=[sorted;[0,0]];
                    sorted(n,1)=k(t);
                    sorted(n,2)=p(t);
                    n=n+1;
                else
                    z=[];% set z=[]
                    sa=size(sorted)
                    z=[z;[k(t),p(t)]];
                    pz=ones(sa,1)*z-sorted;
                    jug=logical(size(find(sum(abs(pz)')'==0),1))%判定结果
                    if jug==0
                        sorted=[sorted;[0,0]];
                        sorted(n,1)=k(t);
                        sorted(n,2)=p(t);
                        n=n+1; 
                    end
                end
            end
        end
    end
    