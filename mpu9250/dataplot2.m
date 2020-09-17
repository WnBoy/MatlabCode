%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%�����Ԥ�������%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
newData = importdata('./G/G6.tsv', '\t', 2);
data=newData.data;
figure;
% subplot(2,1,1);
% plot(data(:,7));
% xlabel('ʱ��/s');
% ylabel('-z��Ƕ�/��');
% title('����ǽ�����');
% subplot(2,1,2);
[m, n]=size(data);
dir_p=[];
 for i=1:m-14
     tdirp=sum(data(i:i+14,7))/15;  
     dir_p = cat(1,dir_p,tdirp);
 end
 
subplot(2,1,1);
plot(-data(:,7));
xlabel('ʱ��/s');
ylabel('+z��Ƕ�/��');
title('���������');
subplot(2,1,2);
plot(-dir_p);
xlabel('ʱ��/s');
ylabel('+z��Ƕ�/��');
title('ƽ���˲���ĺ��������');

%iHDE�㷨���������
SLP=0;%ֱ�б��
[N,M]=size(dir_p);
dir_arr=zeros(1,4);
error=zeros(N,1);%�Ƕ����,����0����ƫ��С��0����ƫ������Ǽ�ȥ���ֵ
for k=4:N
    %ֱ���ж�
    for t=1:3
        dir_arr(t)=abs(dir_p(k-t)-mean(dir_p(k-3:k)));
    end
    max_dir=max(dir_arr);
    if(max_dir<15) 
        SLP=1;
    end
   
    if SLP==1
      %ֱ������£�����ǵĹ۲�ֵֵ���������ں���ǵ�ƽ��ֵ
      %����ǵ����ֵ���ڵ�ǰ����ǵ�ֵ��ȥ����ǵĹ۲�ֵ
      error(k)=dir_p(k)-mean(dir_p(k-3:k));  
    end
    
   %�������ж�
   E=45-mod(dir_p(k),90);
    if abs(E)>30&&SLP==1%˵������������ֱ��,ȡ�۲�ֵΪ�������ֵ����ԭ�ȵ����ֵ����
        if dir_p(k)>0&&dir_p(k)<15
            error(k)=dir_p(k)-0;
        end
        if dir_p(k)>345&&dir_p(k)<360
            error(k)=dir_p(k)-360;
        end
        if dir_p(k)>75&&dir_p(k)<105
            error(k)=dir_p(k)-90;
        end
         if dir_p(k)>165&&dir_p(k)<195
            error(k)=dir_p(k)-180;
        end
        if dir_p(k)>255&&dir_p(k)<285
            error(k)=dir_p(k)-90;
        end               
    end     
end

%���������ֵ���뵽�������˲���

dir_Q = 5;%ϵͳ����
dir_R = 5;% ��������

dir_xhat=zeros(N,1);       % x�ĺ������
dir_P=5;           % ���鷽�����  n*n
dir_xhatminus=zeros(N,1);  % x���������
dir_Pminus=0;      % n*n
dir_K=0;   % Kalman����  n*m

dir_cor=zeros(N,1);
% ���Ƶĳ�ʼֵ��ΪĬ�ϵ�0����P=[0 0;0 0],xhat=0
for r = 2:N         
    % ʱ����¹���
    dir_xhatminus(r) = dir_xhat(r-1);
    dir_Pminus= dir_P+dir_Q;
    
    % �������¹���
    dir_K = dir_Pminus*inv( dir_Pminus+dir_R );
    dir_xhat(k) = dir_xhatminus(k)+dir_K*(error(k)-dir_xhatminus(k));
    dir_P = (1-dir_K)*dir_Pminus;
    
    %�������������ֵ��ȥ���ֵ
    dir_cor=dir_p(k)-dir_xhat(k);
end

figure; 
plot(dir_cor);
title('iHDE�㷨�����ĺ����');
xlabel('��λ��������');
ylabel('��λ��m/s2'); 

