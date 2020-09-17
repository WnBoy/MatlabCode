%%%%%%%%%%%%%%%%%%%%%
%����pdr����  V:2.0--[�ŵ�����ϵ�]
%input��3����ٶȺͺ���Ƕ�
%output����������������һ���ĺ���
%�Ľ��㣺�����v1������iHDE�㷨
%p2.5�����ݺܺ�
%ר�Ų� �����Ρ�
%%%%%%%%%%%%%%%%%%%%%
clc;
%1.��������
newData = importdata('./P2/3.tsv', '\t', 2);
data=newData.data;
%2.���㵼������ݵ�����(m)������(n)
[m, n]=size(data);
%3.���ԭʼ��������ٵ����� 
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
asup_h=asum(50:680);
% g=1.02649;
g=1.0704;
%apsum��ȥ�����Ժ�ļ��ٶ�
apsum=asup_h-g;
figure; 
plot(apsum);
title('������ٶȵĺ�ȥ�������Ժ�ļ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2'); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ٶȴ���
[N_a,M_a]=size(apsum);
%�������˲�������ٶ�
Q_a = 0.1;%ϵͳ����
R_a = 0.3;% ��������

% ����ռ�
xhat_a=zeros(N_a,1);       % x�ĺ������
P_a=0.5;           % ���鷽�����  n*n
xhatminus_a=zeros(N_a,1);  % x���������
Pminus_a=0;      % n*n
K_a=0;   % Kalman����  n*m

% ���Ƶĳ�ʼֵ��ΪĬ�ϵ�0����P=[0 0;0 0],xhat=0
for k = 2:N_a         
    % ʱ����¹���
    xhatminus_a(k) = xhat_a(k-1);
    Pminus_a= P_a+Q_a;
    
    % �������¹���
    K_a = Pminus_a*inv( Pminus_a+R_a );
    xhat_a(k) = xhatminus_a(k)+K_a*(apsum(k)-xhatminus_a(k));
    P_a = (1-K_a)*Pminus_a;
end
figure; 
plot(xhat_a);
title('�������˲����������ٶȵĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2'); 

% ���ٶ�ƽ���˲�1
apsum_a1=[];
 for i=1:N_a-10
     temp=sum(xhat_a(i:i+10,:))/11;  
     apsum_a1 = cat(1,apsum_a1,temp);
 end

% figure; 
% plot(apsum_a1);
% title('ƽ���˲�1���������ٶȵĺͼ��ٶ�');
% xlabel('��λ��������');
% ylabel('��λ��m/s2');

[P,Q]=size(apsum_a1);
% ���ٶ�ƽ���˲�2
apsum_a2=[];
 for i=1:P-4
     temp=sum(apsum_a1(i:i+4,:))/5;  
     apsum_a2 = cat(1,apsum_a2,temp);
 end

figure; 
plot(apsum_a2);
title('ƽ���˲�2���������ٶȵĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');

 
 %ƽ���˲���ļ��ٶ� �к�����
[Z,O1]=size(apsum_a2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ptemp=0;%�����м�ֵ
k=1;%����ģ������%%%%%%%%%%%%%%%%%%%%%%%%%%%���ⶨ
plength=0;%����
pzero=0;%������
pb=0;%һ����ʼ��ʱ��
pmax=0;%��¼��ֵ���ֵ
pflag=0;%���Ϊ���Ŀ�ʼ
tflag=0;
pclimbing=0;%�������
min=0.15;%һ���еļ��ٶ���Сֵ
max_a=-0.1;%һ���еļ��ٶ����ֵ
step=0;%����
sflag=0;%������ֵ���λ
climbing=0;%�������
status=1;%��ǰ״̬��1Ϊ����״̬��2Ϊ��ֵ״̬
down=0;%�½����

for i=2:Z-8
    if apsum_a2(i)>max_a
        max_a=apsum_a2(i);
    end
    if apsum_a2(i)<min
        min=apsum_a2(i);
    end
    if apsum_a2(i)>apsum_a2(i-1)
        climbing=climbing+1;
    end
    if apsum_a2(i)<apsum_a2(i-1)
        down=down+1;
    end
    if down>10
        status=1;
    end
    if status==2&&i-i0<8
        if apsum_a2(i)>apsum_a2(sflag(step+1))
            sflag(step+1)=i;
            pmax=apsum_a2(i);
        end
    end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     ��㽻��  
    if pflag==1&&apsum_a2(tflag+8)<0.025
        pflag=0; 
    end

    if pflag==1&&apsum_a2(i)>apsum_a2(i-1)
        pclimbing=pclimbing+1;
    end
       
    %�����ж�һ���Ŀ�ʼ�����
    if pflag==1&&pclimbing>5&&apsum_a2(tflag+pclimbing)>0.035
        pb=[pb tflag];%һ����ʼ��ʱ�� 
        ptemp=k*(pmax-min)^(1/4);%��ȡ����
        plength=[plength ptemp];%��������
        pflag=0; 
        pzero=pzero+1;
    end
    
    if apsum_a2(i)>0&&apsum_a2(i-1)<0
        tflag=i;%���µ�ǰ�����ʱ��
        pflag=1;%���Ϊ���Ŀ�ʼ
        pclimbing=0;%���Ŀ�ʼ�Ժ��������ĵ���      
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ֵ���
    if apsum_a2(i)>apsum_a2(i+1)&&apsum_a2(i)>apsum_a2(i-1)
%         if max_a>0.045&&climbing>10&&apsum_e(i)>0.04
        if apsum_a2(i)>0.045&&climbing>8
            i0=i;
            pmax=apsum_a2(i);
            status=2;
            step=step+1;          
%             max_a=min;
            min=apsum_a2(i);
            sflag=[sflag i];
            climbing=0;
            down=0;
        end
    end    
end
figure;
sflag=sflag(2:step+1);%��ֵ����
pb=pb(2:pzero+1);%�������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on;
scatter(sflag,apsum_a2(sflag),90,'rp');
scatter(pb,apsum_a2(pb),70,'gO');
plot(apsum_a2,'b');
% title('���ٶȵĲ����������');
xlabel('������');
ylabel('���ٶȷ�ֵ(m/s2)');
legend('��ֵ��','���','���ٶȷ�ֵ');
pzero
step




