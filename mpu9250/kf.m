%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%���ٶ�Ԥ�������%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%
%�����ǿ������˲���Ȼ����2��ƽ���˲�
%%%%%%%%%%%%%%%%%%
newData = importdata('./T/T2.tsv', '\t', 2);
data=newData.data;

[m, n]=size(data);
% figure;
% subplot(3,1,1);
% plot(data(:,2));
% title('������ٶȴ�������ȡ������');
% xlabel('X��ɼ�����');
% subplot(3,1,2);
% plot(data(:,3));
% xlabel('Y��ɼ�����');
% ylabel('��λ��m/s2');
% subplot(3,1,3);
% plot(data(:,4));
% xlabel('Z��ɼ�����  ��λ:������');

%���ٶȷ�ֵ
asum=sqrt(data(:,2).^2+data(:,3).^2+data(:,4).^2);
% figure;
% plot(asum);
% title('������ٶȵĺͼ��ٶ�');
% xlabel('��λ��������');
% ylabel('��λ��m/s2');

g=1.02649;
%apsum��ȥ�����Ժ�ļ��ٶ�
apsum=asum-g;
 
figure; 
% subplot(2,1,1);
plot(apsum);
title('������ٶȵĺ�ȥ�������Ժ�ļ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');
% subplot(2,1,2);

[N,M]=size(apsum);

Q = 0.1;%ϵͳ����
R = 0.2;% ��������

% ����ռ�
xhat=zeros(N,1);       % x�ĺ������
P=0.2;           % ���鷽�����  n*n
xhatminus=zeros(N,1);  % x���������
Pminus=0;      % n*n
K=0;   % Kalman����  n*m

% ���Ƶĳ�ʼֵ��ΪĬ�ϵ�0����P=[0 0;0 0],xhat=0
for k = 2:N         
    % ʱ����¹���
    xhatminus(k) = xhat(k-1);
    Pminus= P+Q;
    
    % �������¹���
    K = Pminus*inv( Pminus+R );
    xhat(k) = xhatminus(k)+K*(apsum(k)-xhatminus(k));
    P = (1-K)*Pminus;
end
figure; 
plot(xhat);
title('�������˲����������ٶȵĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2'); 

% ƽ���˲�1
apsum_e=[];
 for i=1:m-10
     temp=sum(xhat(i:i+10,:))/11;  
     apsum_e = cat(1,apsum_e,temp);
 end

figure; 
plot(apsum_e);
title('ƽ���˲����������ٶȵĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');

p=size(apsum_e);
% ƽ���˲�2
apsum_e2=[];
 for i=1:p-4
     temp=sum(apsum_e(i:i+4,:))/5;  
     apsum_e2 = cat(1,apsum_e2,temp);
 end

figure; 
plot(apsum_e2);
title('ƽ���˲����������ٶȵĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');
