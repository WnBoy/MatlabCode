
clc;
clear all;
x=zeros(50,2);
x(1,:)=[10 10];
for i=2:50
   x(i,1)=awgn(x(1,1),15);
   x(i,2)=awgn(x(1,2),15);
end
figure;
plot(x(:,1),x(:,2),'x');
axis([9.4 10.6 9.4 10.6]);

%���������߾������ֵ����
fid=fopen('bds.txt','wt');%д���ļ�·��
matrix=x;                       %input_matrixΪ���������
   [m,n]=size(matrix);
  for i=1:1:m
     for j=1:1:n
        if j==n
         fprintf(fid,'%.4f\n',matrix(i,j));
        else 
         fprintf(fid,'%.4f\t',matrix(i,j));
        end
     end
 end
 fclose(fid);
