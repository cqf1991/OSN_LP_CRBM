%%�����ɵ�ÿһƬд�뵽txt�ı��У��Ա� R ��ȡ
function [] = file2txt(da,sl)
dat1 = da(:,1);
dat2 = da(:,2);
dat3 = da(:,3);
dat = [dat1,dat2,dat3];
ss = num2str(sl);     %������ת�����ַ���
file =strcat('C:\Users\XF-pc\Desktop\multislice network\MSNs data\slice\slice',ss,'.txt'); 
fid = fopen(file,'w');

 fprintf(fid,'%d %d\n',dat);
    
   % fprintf(fid,'\t');

fclose(fid);
end