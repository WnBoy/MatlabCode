clc;
clear all;
realPos=zeros(35,2);%��ʼ����ʵλ��
realPos(1,:)=[9,10.2];
for i=2:13
   realPos(i,1)=9; 
   realPos(i,2)=10.2-0.6*(i-1);
end
k=1;
for i=14:23
    realPos(i,1)=9-0.6*k; 
    realPos(i,2)=3; 
    k=k+1;
end
j=1;
for i=24:35
    realPos(i,1)=3; 
    realPos(i,2)=3+0.6*j; 
    j=j+1;
end

%��ʵ�������ݴ洢��txt�ļ�
% fid=fopen('r_p.txt','wt');%д���ļ�·��
% matrix=realPos;                       %input_matrixΪ���������
%    [m,n]=size(matrix);
%   for i=1:1:m
%      for j=1:1:n
%         if j==n
%          fprintf(fid,'%.4f\n',matrix(i,j));
%         else 
%          fprintf(fid,'%.4f\t',matrix(i,j));
%         end
%      end
%  end
%  fclose(fid);
 
%�������߾������ֵ
realdata=zeros(35,4);
for i=1:35
   realdata(i,1)=sqrt((realPos(i,1)- 9)^2+(realPos(i,2)- 10.8)^2);
   realdata(i,2)=sqrt((realPos(i,1)- 9)^2+(realPos(i,2)- 0.75)^2);
   realdata(i,3)=sqrt((realPos(i,1)- 3)^2+(realPos(i,2)- 0.75)^2);
   realdata(i,4)=sqrt((realPos(i,1)- 3)^2+(realPos(i,2)- 10.8)^2); 
end
%���������߾������ֵ����
fid=fopen('r_d.txt','wt');%д���ļ�·��
matrix=realdata;                       %input_matrixΪ���������
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

 