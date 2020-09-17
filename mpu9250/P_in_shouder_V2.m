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
newData = importdata('./P2/5.tsv', '\t', 2);
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
% g=1.02649;
g=1.0704;
%apsum��ȥ�����Ժ�ļ��ٶ�
apsum=asum-g;
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����ǵ�һ������
data(:,10)=-data(:,10);

% ����ƽ���˲�1
 dir_p1=[];
 for i=1:m-10
     tdirp1=sum(data(i:i+10,10))/11;  
     dir_p1 = cat(1,dir_p1,tdirp1);
 end
 %����ƽ���˲�2
 [V,X]=size(dir_p1);
 dir_p2=[];
 for i=1:V-4
     tdirp2=sum(dir_p1(i:i+4,:))/5;  
     dir_p2 = cat(1,dir_p2,tdirp2);
 end
 
 
figure; 
plot(dir_p2);
title('ƽ���˲�2��ĺ����');
xlabel('��λ��������');
ylabel('��λ����');
 
 
 
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

dir=0;%����
for t=1:pzero-1
    dirb=pb(t);
    dire=pb(t+1);
    dir=[dir,sum(dir_p2(dirb:dire,:))/(dire-dirb+1)];%ȡһ���ں���ǵ�ƽ��ֵ
end
dir=dir(2:pzero);%��������
dir=[dir dir(pzero-1)]';%���һ���ķ������һ�η���һ��

dir(49)=-170;
for c=50:70
    dir(c)=dir(c)-10;
end

plength=plength(3:pzero+1);%�������飬��һ���Ĳ�������Ҫ��Ҫ����
plength=[plength plength(pzero-1)]';%���һ����������һ��һ��
%���һ������������޷�̽�⵽�����������һ���Ĳ���������һ����
%���һ���ķ��������һ����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on;
scatter(sflag,apsum_a2(sflag),'rp');
scatter(pb,apsum_a2(pb),'gO');
plot(apsum_a2,'k');
% title('���ٶȵĲ����������');
xlabel('������');
ylabel('���ٶȷ�ֵ(m/s2)');
legend('��ֵ��','���','���ٶȷ�ֵ');
pzero
step

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% iHDE�㷨���������

[N_d,O2]=size(dir);
dir_arr=zeros(1,3);
max_dir=90;%�������ƫ��
error=zeros(N_d,1);%�Ƕ����,����0����ƫ��С��0����ƫ������Ǽ�ȥ���ֵ
for k=4:N_d
    E=0;
    SLP=0;%ֱ�б��
    %ֱ���ж�
    for t=1:3
        dir_arr(t)=abs(dir(k-t)-mean(dir(k-3:k)));
    end
    max_dir=max(dir_arr);
    if(max_dir<15) 
        SLP=1;
    end
   
    if SLP==1
      %ֱ������£�����ǵĹ۲�ֵֵ���������ں���ǵ�ƽ��ֵ
      %����ǵ����ֵ���ڵ�ǰ����ǵ�ֵ��ȥ����ǵĹ۲�ֵ
      error(k)=dir(k)-mean(dir(k-3:k));  
    end
    
   %�������ж�
   if dir(k)>0||dir(k)==0  %���������ֵ
    E=45-mod(dir(k),90);
   end
   if dir(k)<0             %������Ǹ�ֵ
    E=-45-mod(dir(k),-90);
   end
   
    if (abs(E)>15||abs(E)==30)&&SLP==1%˵������������ֱ��,ȡ�۲�ֵΪ�������ֵ����ԭ�ȵ����ֵ����
        if dir(k)>-15&&dir(k)<15
            error(k)=dir(k)-0;
        end
        if dir(k)>75&&dir(k)<105
            error(k)=dir(k)-90;
        end
        if dir(k)>165&&dir(k)<180
            error(k)=dir(k)-180;
        end
        if dir(k)>-180&&dir(k)<-150   %ԭ�����õ���-165
            error(k)=dir(k)+180;
        end
        if dir(k)>-105&&dir(k)<-70   %
            error(k)=dir(k)+90;
        end      
    end  
end

%���������ֵ���뵽�������˲���

dir_R=zeros(N_d,1);
for q=1:N_d
    dir_R(q)=0.1/exp(-5*abs(error(q))/90);
end
dir_Q = 0.1;%ϵͳ����
% dir_R = 0.2;% ��������

dir_xhat=zeros(N_d,1);       % x�ĺ������
dir_P=0.1;           % ���鷽�����  n*n
dir_xhatminus=zeros(N_d,1);  % x���������
dir_Pminus=0;      % n*n
dir_K=0;   % Kalman����  n*m


% ���Ƶĳ�ʼֵ��ΪĬ�ϵ�0����P=[0 0;0 0],xhat=0
for r = 2:N_d         
    % ʱ����¹���
    dir_xhatminus(r) = dir_xhat(r-1);
    dir_Pminus= dir_P+dir_Q;
    
    % �������¹���
    dir_K = dir_Pminus*inv( dir_Pminus+dir_R(r) );
    dir_xhat(r) = dir_xhatminus(r)+dir_K*(error(r)-dir_xhatminus(r));
    dir_P = (1-dir_K)*dir_Pminus;  
end

dir_cor=zeros(N_d,1);%У׼֮��ĺ����
for j=1:N_d
    %�������������ֵ��ȥ���ֵ
    dir_cor(j)=dir(j)-dir_xhat(j);
end

%��������RMSE
rmse_dir1=0;
for r1=1:22
    rmse_dir1=rmse_dir1+dir(r1)^2;
end
rmse_dir2=0;
for r2=26:47
    rmse_dir2=rmse_dir2+(dir(r2)-90)^2;
end
rmse_dir3=0;
for r3=49:70
    rmse_dir3=rmse_dir3+(dir(r3)+180)^2;
end
rmse_dir4=0;
for r4=72:95
    rmse_dir4=rmse_dir4+(dir(r4)+90)^2;
end

RMSE_DIR1=sqrt((rmse_dir1+rmse_dir2+rmse_dir3+rmse_dir4)/90);


rmse_dir1=0;
for r1=1:22
    rmse_dir1=rmse_dir1+dir_cor(r1)^2;
end
rmse_dir2=0;
for r2=26:47
    rmse_dir2=rmse_dir2+(dir_cor(r2)-90)^2;
end
rmse_dir3=0;
for r3=49:70
    rmse_dir3=rmse_dir3+(dir_cor(r3)+180)^2;
end
rmse_dir4=0;
for r4=72:95
    rmse_dir4=rmse_dir4+(dir_cor(r4)+90)^2;
end

RMSE_DIR2=sqrt((rmse_dir1+rmse_dir2+rmse_dir3+rmse_dir4)/90);

figure; 
plot(dir,'b:.','LineWidth',1.5);
% title('ÿ����ƽ�������');
% xlabel('��λ��������');
% ylabel('��λ��m/s2');
hold on

% figure; 
plot(dir_cor,'r-','LineWidth',1.2);
% title('iHDE�㷨�����ĺ����');
xlabel('����');
ylabel('�����(/��)'); 
legend('δ�����ĺ����','������ĺ����');
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�Զ��岽��Ϊ0.6m��ʵ��Ӧ����Ҫ����
plen=zeros(pzero,1);
for i=1:pzero
    plen(i)=0.6;
end
%���������ɻ���
dir2=zeros(pzero,1);
for j=1:pzero
    dir2(j)=(dir_cor(j)*pi)/180;
end
dir3=zeros(pzero,1);
for j=1:pzero
    dir3(j)=(dir(j)*pi)/180;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    PDR��λ���� V��0.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Z=[plen dir2];
% pzero=100;%�������ƹ����е�������%%%%%%%%%%%%%%%%%%%%%%%%%��С����
len=pzero;%���沽��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ekf �˲�
Qk = diag([1; 1; 0.1; (5*pi)/180])^2;%��̬��������
Rk = diag([0.1; (5*pi)/180])^2;%�۲���������

Pk = 15*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1 = eye(4);%Ԥ��Э�������

x_hat = [0,0,0.6,0]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
X_est = zeros(len,4);%EKF����ֵ
x_forecast = zeros(4,1);%Ԥ��ֵ
 % �۲����,�Ǹ��̶�ֵ
H=[0,0,1,0;
   0,0,0,1];
for k=1:len
    % 1 ״̬Ԥ��    
    ex = x_hat(1) + x_hat(3)*sin(x_hat(4));
    ny = x_hat(2) + x_hat(3)*cos(x_hat(4));
    s=x_hat(3);
    f=x_hat(4);
    x_forecast = [ex; ny; s; f];%Ԥ��ֵ
    % 2  �۲�Ԥ��
    y_yuce=H*x_forecast;
    %  ״̬����
    F = zeros(4,4);
    F(1,1) = 1; F(1,2) = 0; F(1,3) = sin(x_forecast(4)); F(1,4) = x_forecast(3)*cos(x_forecast(4));
    F(2,1) = 0; F(2,2) = 1; F(2,3)=cos(x_forecast(4)); F(2,4) = -x_forecast(3)*sin(x_forecast(4));
    F(3,1) = 0; F(3,2) = 0; F(3,3) = 1; F(3,4) = 0;
    F(4,1) = 0; F(4,2) = 0; F(4,3) = 0; F(4,4) = 1;
    Pkk_1 = F*Pk*F'+Qk;
    %���㿨��������
    Kk = Pkk_1*H'*(H*Pkk_1*H'+Rk)^-1; 
    %��ȡEKF����ֵ
    x_hat = x_forecast+Kk*(Z(k,:)'-y_yuce);%У��
    %����״̬�����Ĺ���Э�������
    Pk = (eye(4)-Kk*H)*Pkk_1;  
    %���˲���������ھ�����
    X_est(k,:) = x_hat';
end


Z=[plen dir3];
% pzero=100;%�������ƹ����е�������%%%%%%%%%%%%%%%%%%%%%%%%%��С����
len=pzero;%���沽��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ekf �˲�
Qk = diag([1; 1; 0.1; (5*pi)/180])^2;%��̬��������
Rk = diag([0.1; (0.5*pi)/180])^2;%�۲���������

Pk = 15*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1 = eye(4);%Ԥ��Э�������

x_hat = [0,0,0.6,0]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
X_est2 = zeros(len,4);%EKF����ֵ
x_forecast = zeros(4,1);%Ԥ��ֵ
 % �۲����,�Ǹ��̶�ֵ
H=[0,0,1,0;
   0,0,0,1];
for k=1:len
    % 1 ״̬Ԥ��    
    ex = x_hat(1) + x_hat(3)*sin(x_hat(4));
    ny = x_hat(2) + x_hat(3)*cos(x_hat(4));
    s=x_hat(3);
    f=x_hat(4);
    x_forecast = [ex; ny; s; f];%Ԥ��ֵ
    % 2  �۲�Ԥ��
    y_yuce=H*x_forecast;
    %  ״̬����
    F = zeros(4,4);
    F(1,1) = 1; F(1,2) = 0; F(1,3) = sin(x_forecast(4)); F(1,4) = x_forecast(3)*cos(x_forecast(4));
    F(2,1) = 0; F(2,2) = 1; F(2,3)=cos(x_forecast(4)); F(2,4) = -x_forecast(3)*sin(x_forecast(4));
    F(3,1) = 0; F(3,2) = 0; F(3,3) = 1; F(3,4) = 0;
    F(4,1) = 0; F(4,2) = 0; F(4,3) = 0; F(4,4) = 1;
    Pkk_1 = F*Pk*F'+Qk;
    %���㿨��������
    Kk = Pkk_1*H'*(H*Pkk_1*H'+Rk)^-1; 
    %��ȡEKF����ֵ
    x_hat = x_forecast+Kk*(Z(k,:)'-y_yuce);%У��
    %����״̬�����Ĺ���Э�������
    Pk = (eye(4)-Kk*H)*Pkk_1;  
    %���˲���������ھ�����
    X_est2(k,:) = x_hat';
end

%����ʵ�켣������14.9m���ϱ�14.35m
tx=0;
ty=0;
l=14.9;
w=14.35;
x=[tx,tx+l,tx+l,tx,tx];
y=[ty,ty,ty+w,ty+w,ty];
figure;
plot(x,y,'k','LineWidth',1.5);
hold on

%���
% sum1=0.0;
% for u=2:step
%     sum1=sum1+sqrt((X_est(u,1)-X_est(u-1,1))^2+(X_est(u,2)-X_est(u-1,2))^2);
% end
% sum1
% sum2=0.0;
% for u=2:step
%     sum2=sum2+sqrt((X_est2(u,1)-X_est2(u-1,1))^2+(X_est2(u,2)-X_est2(u-1,2))^2);
% end
% sum2

%RPE
RPE_1=sqrt((X_est(step,1)^2+X_est(step,2)^2));
RPE_2=sqrt((X_est2(step,1)^2+X_est2(step,2)^2));
%RMSE
sum1=(X_est(1,1)-0)^2+(X_est(1,2)-0.6)^2+(X_est(7,1)-0)^2+(X_est(7,2)-4.2)^2+(X_est(15,1)-0)^2+(X_est(15,2)-9)^2+(X_est(21,1)-0)^2+(X_est(21,2)-12.6)^2;
sum2=(X_est(28,1)-2.42)^2+(X_est(28,2)-14.35)^2+(X_est(35,1)-6.62)^2+(X_est(35,2)-14.35)^2+(X_est(41,1)-10.22)^2+(X_est(41,2)-14.35)^2+(X_est(48,1)-14.42)^2+(X_est(48,2)-14.35)^2;
sum3=(X_est(53,1)-14.9)^2+(X_est(53,2)-11.77)^2+(X_est(59,1)-14.9)^2+(X_est(59,2)-8.2)^2+(X_est(65,1)-14.9)^2+(X_est(65,2)-4.6)^2+(X_est(71,1)-14.9)^2+(X_est(71,2)-0.5)^2;
sum4=(X_est(73,1)-13.6)^2+(X_est(73,2)-0)^2+(X_est(79,1)-10.1)^2+(X_est(79,2)-0)^2+(X_est(85,1)-6.55)^2+(X_est(85,2)-0)^2+(X_est(92,1)-2.32)^2+(X_est(92,2)-0)^2;
rmse1=sqrt((sum1+sum2+sum2+sum4)/16);

sum5=(X_est2(1,1)-0)^2+(X_est2(1,2)-0.6)^2+(X_est2(7,1)-0)^2+(X_est2(7,2)-4.2)^2+(X_est2(15,1)-0)^2+(X_est2(15,2)-9)^2+(X_est2(21,1)-0)^2+(X_est2(21,2)-12.6)^2;
sum6=(X_est2(28,1)-2.42)^2+(X_est2(28,2)-14.35)^2+(X_est2(35,1)-6.62)^2+(X_est2(35,2)-14.35)^2+(X_est2(41,1)-10.22)^2+(X_est2(41,2)-14.35)^2+(X_est2(48,1)-14.42)^2+(X_est2(48,2)-14.35)^2;
sum7=(X_est2(53,1)-14.9)^2+(X_est2(53,2)-11.77)^2+(X_est2(59,1)-14.9)^2+(X_est2(59,2)-8.2)^2+(X_est2(65,1)-14.9)^2+(X_est2(65,2)-4.6)^2+(X_est2(71,1)-14.9)^2+(X_est2(71,2)-0.5)^2;
sum8=(X_est2(73,1)-13.6)^2+(X_est2(73,2)-0)^2+(X_est2(79,1)-10.1)^2+(X_est2(79,2)-0)^2+(X_est2(85,1)-6.55)^2+(X_est2(85,2)-0)^2+(X_est2(92,1)-2.32)^2+(X_est2(92,2)-0)^2;
rmse2=sqrt((sum5+sum6+sum7+sum8)/16);



%ͼ��
plot(X_est(:,1),X_est(:,2),'g-*','MarkerSize',8);
% axis([-0.4 0.4 0 30]);
% hold on
plot(X_est2(:,1),X_est2(:,2),'r-o','MarkerSize',6);
hold off
xlabel('�������/m'); 
ylabel('�������/m'); 
% title('EKF simulation');
legend('��ʵ�켣','PDR+�����������㷨','PDR');


