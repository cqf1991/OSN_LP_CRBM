function re = Adj2Array(A)
%�����Ż�
Asize=length(A);
Tr=triu(A);
temp=1;
trNum=zeros(1,Asize*(Asize-1)/2);
for i=1:Asize
    for j=i+1:Asize
        trNum(temp)=A(i,j);
        temp=temp+1;
    end
end
re=trNum(trNum~=0);%ȥ��Ԫ���е�0