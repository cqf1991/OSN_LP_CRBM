%%把生成的每一片写入到txt文本中，以便 R 读取
function [] = file2txt(da,sl)
dat1 = da(:,1);
dat2 = da(:,2);
dat3 = da(:,3);
dat = [dat1,dat2,dat3];
ss = num2str(sl);     %将数字转换成字符串
file =strcat('C:\Users\XF-pc\Desktop\multislice network\MSNs data\slice\slice',ss,'.txt'); 
fid = fopen(file,'w');

 fprintf(fid,'%d %d\n',dat);
    
   % fprintf(fid,'\t');

fclose(fid);
end