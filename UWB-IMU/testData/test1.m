clc;
clear all;
a=textread('4.8m.txt','%s');%��TXT�е��������ı��ķ�ʽȡ�� 
aa=cell2mat(a);
b=hex2dec(aa);

cc=zeros(12,4);
k=1;
for i=1:12
   for j=1:4
    cc(i,j)=b(k)/1000;
    k=k+1;
   end
end
r=mean(cc,1);



