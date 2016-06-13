cLen=1;
C=[];
for i=1:length(A)
    for j=1:length(A)
        C(cLen,1)=A(i,j);
        C(cLen,2)=i;
        C(cLen,3)=j;
        cLen=cLen+1;
    end
end