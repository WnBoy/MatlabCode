clc;
clear all;
a=textread('10.4m.txt','%s');%��TXT�е��������ı��ķ�ʽȡ�� 
aa=cell2mat(a);
dd=str2num(aa);

cc=zeros(9,1);
k=1;
for i=1:9
    cc(i)=dd(k);
    k=k+4;
end
r=mean(cc,1)/1000;
r
