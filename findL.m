%%��Ȩֵ�ٽ־���A��Ԫ�ؽ������򣬲��һ�ö�Ӧλ�õ�
function [sorted] = findL(A,timeSlice)
    At=triu(A);%��ȡ����������Ǿ���
    At=At+diag(-diag(At));%�Խ���Ԫ�ظ�ֵΪ0
    [a,b]=sort(At(:),'descend');%����b�Ƕ�Ӧ��λ��  ����
    sorted=[];%�վ���
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
                    jug=logical(size(find(sum(abs(pz)')'==0),1))%�ж����
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
    