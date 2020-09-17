
clc;
clear all;
%%%%%%%%%%%%%%-------------����UWB��IMU�����ڶ�λ�ں��㷨--------------%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%===============���Լ��ķ���   �����������㷨�ĶԱ�  ģ���ʵ�������Ǵ�Χ  ����ʹ����awg������===============%%%%%%%%%%%%%%%%%%%%%%%
%----1.ģ����Ե���������
%%%---1.1 6����վ������
x1=[1 1];
x2=[1 17];
x3=[9 17];
x4=[17 17];
x5=[17 1];
x6=[9 1];
bs=[x1;x2;x3;x4;x5;x6];
%%%---1.2 ������Ϣ
h=zeros(81,1);
for i=1:20
    h(i)=0;
    h(i+20)=90;
    h(i+40)=180;
    h(i+60)=270;
end
h(81)=270;
% % ������Ǽ�������
% figure;
% plot(h,'g');
% hold on;
h=awgn(h,-10);%������Ǽ����˹������
% plot(h,'r');

%�������Ϊ������
for i=1:81
   h(i)=(h(i)*pi)/180;
end
%%%--- 1.4 ���� 
N_P=81;
%%%--- 1.5 ����
N_S=zeros(81,1);
for i=1:81
    N_S(i)=0.6;
end
% figure;
% plot(N_S,'r');
% hold on;
N_S=awgn(N_S,30);%�����������˹������
% plot(N_S,'g');


%%%--- 1.6 ����λ��(2 2)


%ģ��ʵ�ʵ���������λ��
P_P=zeros(81,2);
P_P(1,1)=3;
P_P(1,2)=3;
for i=1:20
  P_P(i+1,1)=3;
  P_P(i+1,2)=0.6+P_P(i,2);
end
for i=22:41
   P_P(i,2)=15;
   P_P(i,1)=P_P(i-1,1)+0.6;
end
for i=42:61
   P_P(i,1)=15; 
   P_P(i,2)=P_P(i-1,2)-0.6;
end
for i=62:81
   P_P(i,1)=P_P(i-1,1)-0.6;
   P_P(i,2)=3;
end
% figure;
% plot(P_P(:,1),P_P(:,2),'*');
%%%ģ��UWB�Ĳ�������
d_UWB_1=zeros(81,1);
for i=1:81
   d_UWB_1(i)= sqrt((P_P(i,1)-x1(1))^2+(P_P(i,2)-x1(2))^2);
end
d_UWB_2=zeros(81,1);
for i=1:81
   d_UWB_2(i)= sqrt((P_P(i,1)-x2(1))^2+(P_P(i,2)-x2(2))^2);
end
d_UWB_3=zeros(81,1);
for i=1:81
   d_UWB_3(i)= sqrt((P_P(i,1)-x3(1))^2+(P_P(i,2)-x3(2))^2);
end
d_UWB_4=zeros(81,1);
for i=1:81
   d_UWB_4(i)= sqrt((P_P(i,1)-x4(1))^2+(P_P(i,2)-x4(2))^2);
end
d_UWB_5=zeros(81,1);
for i=1:81
   d_UWB_5(i)= sqrt((P_P(i,1)-x5(1))^2+(P_P(i,2)-x5(2))^2);
end
d_UWB_6=zeros(81,1);
for i=1:81
   d_UWB_6(i)= sqrt((P_P(i,1)-x6(1))^2+(P_P(i,2)-x6(2))^2);
end
%����UWB��������Ĵ�С
% figure;
% plot(d_UWB_1,'r');
% hold on;

%%%++++++++++++++++++++++++++++++������UWB�������ݼ����˹����
d_UWB_1=awgn(d_UWB_1,20);
d_UWB_2=awgn(d_UWB_2,20);
d_UWB_3=awgn(d_UWB_3,20);
d_UWB_4=awgn(d_UWB_4,20);
d_UWB_5=awgn(d_UWB_5,20);
d_UWB_6=awgn(d_UWB_6,20);

%���Լ��������Ժ��UWB��������Ĵ�С
% plot(d_UWB_1,'g');

%++++++++++++++++++++++++++++++++��3��4��վ�漴��������ƫ��(����ƫ���СΪ2m)
%��3��վ����50������ƫ��
R_UWB_3=randperm(80)+1;
R_UWB_3_U=R_UWB_3(1:50);
% figure;
% plot(d_UWB_3,'ro');
% hold on;
for i=1:50
   d_UWB_3(R_UWB_3_U(i))= d_UWB_3(R_UWB_3_U(i))+rand(1)+0.6;
end
% plot(d_UWB_3,'go','MarkerSize',13);
%��4��վ����50������ƫ��
R_UWB_4=randperm(80)+1;
R_UWB_4_U=R_UWB_4(1:50);
% figure;
% plot(d_UWB_4,'ro');
% hold on;
for i=1:50
   d_UWB_4(R_UWB_4_U(i))= d_UWB_4(R_UWB_4_U(i))+rand(1)+0.6;
end
% plot(d_UWB_4,'go','MarkerSize',13);

%��6��վ����30������ƫ��
R_UWB_6=randperm(80)+1;
R_UWB_6_U=R_UWB_6(1:50);
for i=1:50
   d_UWB_6(R_UWB_6_U(i))= d_UWB_6(R_UWB_6_U(i))+rand(1)+0.6;
end

% %��1��վ����30������ƫ��
R_UWB_1=randperm(80)+1;
R_UWB_1_U=R_UWB_1(1:50);
for i=1:50
   d_UWB_1(R_UWB_1_U(i))= d_UWB_1(R_UWB_1_U(i))+rand(1)+0.6;
end


len=N_P;%���沽��

% %%%%%---------------------------�������Ե����㷨----------------------%%%%%%%%

% X_est = zeros(len,4);%EKF����ֵ
% X_est(1,:)=[2,2,0.6,0];
% x_hat_P = [2,2,0.6,0]';
% x_forecast = zeros(4,1);%Ԥ��ֵ
% 
% Qk_P = 0.5*diag([0.5; 0.5; 0.1; (5*pi)/180])^2;%��̬��������
% Rk_P = 0.01*diag([0.1; (5*pi)/180])^2;%�۲���������       
% Z_P=[N_S,h];  %���Ե����Ĳ���ֵ��һ������һ������
% Pk_P = 1*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
% Pkk_1_P = eye(4);%Ԥ��Э�������
% 
%  % �۲����,�Ǹ��̶�ֵ
% H_P=[0,0,1,0;
%     0,0,0,1];
% for k=2:len
%     % 1 ״̬Ԥ��    
%     ex = x_hat_P(1) + x_hat_P(3)*sin(x_hat_P(4));
%     ny = x_hat_P(2) + x_hat_P(3)*cos(x_hat_P(4));
%     s=x_hat_P(3);
%     f=x_hat_P(4);
%     x_forecast = [ex; ny; s; f];%Ԥ��ֵ
%     % 2  �۲�Ԥ��
%     y_yuce=H_P*x_forecast;
%     %  ״̬����
%     F = zeros(4,4);
%     F(1,1) = 1; F(1,2) = 0; F(1,3) = sin(x_forecast(4)); F(1,4) = x_forecast(3)*cos(x_forecast(4));
%     F(2,1) = 0; F(2,2) = 1; F(2,3)=cos(x_forecast(4)); F(2,4) = -x_forecast(3)*sin(x_forecast(4));
%     F(3,1) = 0; F(3,2) = 0; F(3,3) = 1; F(3,4) = 0;
%     F(4,1) = 0; F(4,2) = 0; F(4,3) = 0; F(4,4) = 1;
%     Pkk_1_P = F*Pk_P*F'+Qk_P;%�ߵ���Ԥ��Э�������   
% %     ���㿨��������
%     Kk = Pkk_1_P*H_P'*(H_P*Pkk_1_P*H_P'+Rk_P)^-1; 
%     %��ȡEKF����ֵ
%     x_hat_P = x_forecast+Kk*(Z_P(k,:)'-y_yuce);%У��
%     %����״̬�����Ĺ���Э�������
%     Pk_P = (eye(4)-Kk*H_P)*Pkk_1_P;  
%     %���˲���������ھ�����
%     X_est(k,:) = x_hat_P';  
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���Զ��塿�����ں��㷨%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%%%%%    ���ںϲ���EKF���ݵĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%
               
% %����dΪ��n����ǩ����վ�ľ���  ---- ������6����վ
d=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,d_UWB_5,d_UWB_6];
residual=zeros(6,1);
Z_R=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,d_UWB_5,d_UWB_6,N_S,h]; %  -----  �ں�EKF�Ĳ���ֵ ��6�����룬һ��������һ������ n��8��
HH_R=zeros(8,4);
X_est_R = zeros(len,4);     %----  �ںϵ�EKF���Ź���ֵ
X_est_R(1,:)=[3,3,0.6,0];
P_R=0.1*eye(4);%����Э�������ĳ�ʼֵ
P_R(4,4)=P_R(4,4)*40;
R_F = diag([0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 0.1; (0.1*pi)/180])^2;  %���ںϡ��۲���������
x_R=[3,3,0.6,0]';%״̬�����ĳ�ʼֵ
R_R_R=zeros(len,6);
d_t_1=zeros(6,1);
Threshold=0.4; %%%%-----NLOS���



%%%%%%%%%%%%%%%%%%%%%%%%%%%%       �����Ե�����EKF�ĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���Ե���ʹ��ekf �ó���ǰλ��
Qk = 0.5*diag([0.5; 0.5; 0.1; (5*pi)/180])^2;%��̬��������
Rk = 0.01*diag([0.1; (5*pi)/180])^2;%�۲���������       
Z=[N_S,h];  %���Ե����Ĳ���ֵ��һ������һ������
Pk = 2*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1 = eye(4);%Ԥ��Э�������
x_hat = [3,3,0.6,0]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
 % �۲����,�Ǹ��̶�ֵ
H=[0,0,1,0;
   0,0,0,1];

for k=2:len
   
    %%%%%%%%%%%%%%%%%%%           �����Ե������ֵ�EKF��        %%%%%%%%%%%%%%%%%%
    % 1 ״̬Ԥ��    
    ex_R = x_R(1) + x_R(3)*sin(x_R(4));
    ny_R = x_R(2) + x_R(3)*cos(x_R(4));
    s_R=x_R(3);
    f_R=x_R(4);
    x_forecast_R = [ex_R; ny_R; s_R; f_R];%Ԥ��ֵ
    % 2  �۲�Ԥ��
    y_yuce=H*x_forecast_R;
    %  ״̬����
    F_R = zeros(4,4);
    F_R (1,1) = 1; F_R (1,2) = 0; F_R (1,3) = sin(x_forecast_R(4)); F_R (1,4) = x_forecast_R(3)*cos(x_forecast_R(4));
    F_R (2,1) = 0; F_R (2,2) = 1; F_R (2,3)=cos(x_forecast_R(4)); F_R (2,4) = -x_forecast_R(3)*sin(x_forecast_R(4));
    F_R (3,1) = 0; F_R (3,2) = 0; F_R (3,3) = 1; F_R (3,4) = 0;
    F_R (4,1) = 0; F_R (4,2) = 0; F_R (4,3) = 0; F_R (4,4) = 1;    
    
    Pkk_1 = F_R*Pk*F_R'+Qk;%�ߵ���Ԥ��Э�������   
%     ���㿨��������
    Kk = Pkk_1*H'*(H*Pkk_1*H'+Rk)^-1; 
    %��ȡEKF����ֵ
    x_hat = x_forecast_R+Kk*(Z(k,:)'-y_yuce);%У��
    %����״̬�����Ĺ���Э�������
    Pk = (eye(4)-Kk*H)*Pkk_1;  
    
    %%%%%%%%%%%%%%%%%%%%%%%%%       ��UWB�͹��Ե����ںϲ��ֵ�EKF��      %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    Pkk_R = F_R *P_R*F_R'+Qk;     %���ںϵ�Ԥ��Э�������
        
    %�������������Ÿ��Ⱦ���     ------��b_e,b_n����վ������
    HH_R(1,1)=(x_forecast_R(1)-x1(1))*((x1(1)-x_forecast_R(1))^2 +(x1(2)-x_forecast_R(1))^2)^(-0.5);
    HH_R(1,2)=(x_forecast_R(2)-x1(2))*((x1(1)-x_forecast_R(1))^2 +(x1(2)-x_forecast_R(1))^2)^(-0.5);
    
    HH_R(2,1)=(x_forecast_R(1)- x2(1))*((x_forecast_R(1)- x2(1))^2 +(x_forecast_R(1)-x2(2))^2)^(-0.5);
    HH_R(2,2)=(x_forecast_R(2)- x2(2))*((x_forecast_R(1)- x2(1))^2 +(x_forecast_R(1)-x2(2))^2)^(-0.5); 
    
    HH_R(3,1)=(x_forecast_R(1)- x3(1))*((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(1)- x3(2))^2)^(-0.5);
    HH_R(3,2)=(x_forecast_R(2)- x3(2))*((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(1)- x3(2))^2)^(-0.5);
    
    HH_R(4,1)=(x_forecast_R(1)- x4(1))*((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(1)- x4(2))^2)^(-0.5);
    HH_R(4,2)=(x_forecast_R(2)- x4(2))*((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(1)- x4(2))^2)^(-0.5);
    
    HH_R(5,1)=(x_forecast_R(1)- x5(1))*((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(1)- x5(2))^2)^(-0.5);
    HH_R(5,2)=(x_forecast_R(2)- x5(2))*((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(1)- x5(2))^2)^(-0.5);
    
    HH_R(6,1)=(x_forecast_R(1)- x6(1))*((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(1)- x6(2))^2)^(-0.5);
    HH_R(6,2)=(x_forecast_R(2)- x6(2))*((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(1)- x6(2))^2)^(-0.5); 
   
    HH_R(7,3)=1; 
    HH_R(8,4)=1; 
    
    %Ԥ��ֵ������ֵ
    y_R(1,1)=sqrt((x1(1)-  x_forecast_R(1))^2 +(x1(2)-x_forecast_R(2))^2);
    y_R(2,1)=sqrt((x_forecast_R(1)-  x2(1))^2 +(x_forecast_R(2)- x2(2))^2);
    y_R(3,1)=sqrt((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(2)- x3(2))^2);
    y_R(4,1)=sqrt((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(2)- x4(2))^2);
    y_R(5,1)=sqrt((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(2)- x5(2))^2);
    y_R(6,1)=sqrt((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(2)- x6(2))^2);
    y_R(7,1)=x_forecast_R(3);
    y_R(8,1)=x_forecast_R(4);
    
    %%%�ѵ�ǰʱ�̵Ĺ��Ե�����λ�ù���ֵת��Ϊ   ����ֵ
    y_R_F(1,1)=sqrt((x1(1)-  x_hat(1))^2 +(x1(2)-x_hat(2))^2);
    y_R_F(2,1)=sqrt((x_hat(1)-  x2(1))^2 +(x_hat(2)- x2(2))^2);
    y_R_F(3,1)=sqrt((x_hat(1)-  x3(1))^2 +(x_hat(2)- x3(2))^2);
    y_R_F(4,1)=sqrt((x_hat(1)-  x4(1))^2 +(x_hat(2)- x4(2))^2);
    y_R_F(5,1)=sqrt((x_hat(1)-  x5(1))^2 +(x_hat(2)- x5(2))^2);
    y_R_F(6,1)=sqrt((x_hat(1)-  x6(1))^2 +(x_hat(2)- x6(2))^2);
    
    %%%---NLOS���---%%%  
    r_d=abs(d(k,:)' - y_R_F);
    residual=ones(6,1);
    for i=1:6
        if(r_d(i)>Threshold)
            Temp=r_d(i)-Threshold;
            residual(i)=Temp*10000;  %%����в�
        end
    end
    de=diag([residual(1); residual(2); residual(3); residual(4); residual(5); residual(6); 1; 1]);%�ں������ľ���Ĳв�ϵ��
    R_E=R_F*de;   %----  �ں������ľ���
    %���㿨��������
    K_R = Pkk_R*HH_R'*(HH_R*Pkk_R*HH_R'+R_E)^-1; 
    %���Ź���ֵ
    x_R = x_forecast_R+K_R*(Z_R(k,:)'-y_R);%У��
    %����״̬�����Ĺ���Э�������
    P_R = (eye(4)-K_R*HH_R)*Pkk_R;  
    %���˲���������ھ����У��ںϺ�����Ź���ֵ
    X_est_R(k,:) = x_R';  
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ں��㷨�������Ρ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%%%%%    ���ںϲ���EKF���ݵĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%
               
% %����dΪ��n����ǩ����վ�ľ���  ---- ������6����վ
d=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,d_UWB_5,d_UWB_6];
% residual=zeros(6,1);
Z_R=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,d_UWB_5,d_UWB_6,N_S,h]; %  -----  �ں�EKF�Ĳ���ֵ ��6�����룬һ��������һ������ n��8��
HH_R=zeros(8,4);
X_est_R_I = zeros(len,4);     %----  �ںϵ�EKF���Ź���ֵ
X_est_R_I(1,:)=[3,3,0.6,0];
P_R=1*eye(4);%����Э�������ĳ�ʼֵ
% P_R(4,4)=P_R(4,4)*40;
R_F = diag([0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 0.1; (0.1*pi)/180])^2;  %���ںϡ��۲���������
x_R=[3,3,0.6,0]';%״̬�����ĳ�ʼֵ
R_R_R=zeros(len,6);
d_t_1=zeros(6,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%       �����Ե�����EKF�ĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���Ե���ʹ��ekf �ó���ǰλ��
Qk = 0.5*diag([0.5; 0.5; 0.1; (5*pi)/180])^2;%��̬��������
Rk = 0.01*diag([0.1; (5*pi)/180])^2;%�۲���������       
Z=[N_S,h];  %���Ե����Ĳ���ֵ��һ������һ������
Pk = 1*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1 = eye(4);%Ԥ��Э�������
x_hat = [3,3,0.6,0]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
 % �۲����,�Ǹ��̶�ֵ
H=[0,0,1,0;
   0,0,0,1];

for k=2:len
   
    %%%%%%%%%%%%%%%%%%%           �����Ե������ֵ�EKF��        %%%%%%%%%%%%%%%%%%
    % 1 ״̬Ԥ��    
    ex_R = x_R(1) + x_R(3)*sin(x_R(4));
    ny_R = x_R(2) + x_R(3)*cos(x_R(4));
    s_R=x_R(3);
    f_R=x_R(4);
    x_forecast_R = [ex_R; ny_R; s_R; f_R];%Ԥ��ֵ
    % 2  �۲�Ԥ��
    y_yuce=H*x_forecast_R;
    %  ״̬����
    F_R = zeros(4,4);
    F_R (1,1) = 1; F_R (1,2) = 0; F_R (1,3) = sin(x_forecast_R(4)); F_R (1,4) = x_forecast_R(3)*cos(x_forecast_R(4));
    F_R (2,1) = 0; F_R (2,2) = 1; F_R (2,3)=cos(x_forecast_R(4)); F_R (2,4) = -x_forecast_R(3)*sin(x_forecast_R(4));
    F_R (3,1) = 0; F_R (3,2) = 0; F_R (3,3) = 1; F_R (3,4) = 0;
    F_R (4,1) = 0; F_R (4,2) = 0; F_R (4,3) = 0; F_R (4,4) = 1;    
    Pkk_1 = F_R*Pk*F_R'+Qk;%�ߵ���Ԥ��Э�������   
%     ���㿨��������
    Kk = Pkk_1*H'*(H*Pkk_1*H'+Rk)^-1; 
    %��ȡEKF����ֵ
    x_hat = x_forecast_R+Kk*(Z(k,:)'-y_yuce);%У��
    %����״̬�����Ĺ���Э�������
    Pk = (eye(4)-Kk*H)*Pkk_1;  
    
    
    %%%%%%%%%%%%%%%%%       ��UWB�͹��Ե����ںϲ��ֵ�EKF��      %%%%%%%%%%%%%%%%%%%%%%%%
    Pkk_R = F_R *P_R*F_R'+Qk;     %���ںϵ�Ԥ��Э�������
    
    %ʹ�ù��Ե����õ��ĵ�ǰλ��������������ƶ��ľ���  msd------------????????????��һ��ʱ�̵�λ��Ӧ�����ں��������λ��
    msd=sqrt((x_hat(1)-X_est_R_I(k-1,1))^2+(x_hat(2)-X_est_R_I(k-1,2))^2);
    %����ǰһ��ʱ�̻�վ���ƶ��ڵ�ľ���
    for g=1:6
        d_t_1(g)=sqrt((X_est_R_I(k-1,1)-bs(g,1))^2+(X_est_R_I(k-1,2)-bs(g,2))^2);%%---????��һ��ʱ�̵�λ��Ӧ�����ں��������λ��
    end
    %����в�
    residual=ones(6,1);
    for g=1:6                          %-----�˴�������6����վ
%       residual(g)=abs(msd-abs(d(k-1,g)-d(k,g))-Threshold)*k_r;   %Threshold=-1����  ------   k_rΪ�в����۲�����һ������ϵ��   
        R_R_R(k,g)= msd-abs(d_t_1(g)-d(k,g));  
        if(R_R_R(k,g)<0.3) 
            residual(g)=1000000*abs(R_R_R(k,g));
        end
    end
    %�����ں�ʱ��Ҫ�Ĳ�����������
    de=diag([residual(1); residual(2); residual(3); residual(4); residual(5); residual(6); 1; 1]);%�ں������ľ���Ĳв�ϵ��
    R_E=R_F*de;   %----  �ں������ľ���
    %�������������Ÿ��Ⱦ���     ------��b_e,b_n����վ������
    HH_R(1,1)=(x_forecast_R(1)-x1(1))*((x1(1)-x_forecast_R(1))^2 +(x1(2)-x_forecast_R(1))^2)^(-0.5);
    HH_R(1,2)=(x_forecast_R(2)-x1(2))*((x1(1)-x_forecast_R(1))^2 +(x1(2)-x_forecast_R(1))^2)^(-0.5);
    
    HH_R(2,1)=(x_forecast_R(1)- x2(1))*((x_forecast_R(1)- x2(1))^2 +(x_forecast_R(1)-x2(2))^2)^(-0.5);
    HH_R(2,2)=(x_forecast_R(2)- x2(2))*((x_forecast_R(1)- x2(1))^2 +(x_forecast_R(1)-x2(2))^2)^(-0.5); 
    
    HH_R(3,1)=(x_forecast_R(1)- x3(1))*((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(1)- x3(2))^2)^(-0.5);
    HH_R(3,2)=(x_forecast_R(2)- x3(2))*((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(1)- x3(2))^2)^(-0.5);
    
    HH_R(4,1)=(x_forecast_R(1)- x4(1))*((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(1)- x4(2))^2)^(-0.5);
    HH_R(4,2)=(x_forecast_R(2)- x4(2))*((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(1)- x4(2))^2)^(-0.5);
    
    HH_R(5,1)=(x_forecast_R(1)- x5(1))*((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(1)- x5(2))^2)^(-0.5);
    HH_R(5,2)=(x_forecast_R(2)- x5(2))*((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(1)- x5(2))^2)^(-0.5);
    
    HH_R(6,1)=(x_forecast_R(1)- x6(1))*((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(1)- x6(2))^2)^(-0.5);
    HH_R(6,2)=(x_forecast_R(2)- x6(2))*((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(1)- x6(2))^2)^(-0.5); 
   
    HH_R(7,3)=1; 
    HH_R(8,4)=1; 
    
    %Ԥ��ֵ������ֵ
    y_R(1,1)=sqrt((x1(1)-  x_forecast_R(1))^2 +(x1(2)-x_forecast_R(2))^2);
    y_R(2,1)=sqrt((x_forecast_R(1)-  x2(1))^2 +(x_forecast_R(2)- x2(2))^2);
    y_R(3,1)=sqrt((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(2)- x3(2))^2);
    y_R(4,1)=sqrt((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(2)- x4(2))^2);
    y_R(5,1)=sqrt((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(2)- x5(2))^2);
    y_R(6,1)=sqrt((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(2)- x6(2))^2);
    y_R(7,1)=x_forecast_R(3);
    y_R(8,1)=x_forecast_R(4);
    
    %���㿨��������
    K_R = Pkk_R*HH_R'*(HH_R*Pkk_R*HH_R'+R_E)^-1; 
    %���Ź���ֵ
    x_R = x_forecast_R+K_R*(Z_R(k,:)'-y_R);%У��
    %����״̬�����Ĺ���Э�������
    P_R = (eye(4)-K_R*HH_R)*Pkk_R;  
    %���˲���������ھ����У��ںϺ�����Ź���ֵ
    X_est_R_I(k,:) = x_R';  
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ں��㷨��UWB��INS��NLOS����㷨��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%%%%%    ���ںϲ���EKF���ݵĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%
               
% %����dΪ��n����ǩ����վ�ľ���  ---- ������6����վ
d=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,d_UWB_5,d_UWB_6];
% residual=zeros(6,1);
Z_R=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,d_UWB_5,d_UWB_6,N_S,h]; %  -----  �ں�EKF�Ĳ���ֵ ��6�����룬һ��������һ������ n��8��
HH_R=zeros(8,4);
X_est_R_I_U = zeros(len,4);     %----  �ںϵ�EKF���Ź���ֵ
X_est_R_I_U(1,:)=[3,3,0.6,0];
P_R=1*eye(4);%����Э�������ĳ�ʼֵ
% P_R(4,4)=P_R(4,4)*40;
R_F = diag([0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 0.1; (0.5*pi)/180])^2;  %���ںϡ��۲���������
x_R=[3,3,0.6,0]';%״̬�����ĳ�ʼֵ
R_R_R=zeros(len,6);
d_t_1=zeros(6,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%       �����Ե�����EKF�ĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ���Ե���ʹ��ekf �ó���ǰλ��
Qk = 0.5*diag([0.5; 0.5; 0.1; (5*pi)/180])^2;%��̬��������
Rk = 0.01*diag([0.1; (5*pi)/180])^2;%�۲���������       
Z=[N_S,h];  %���Ե����Ĳ���ֵ��һ������һ������
Pk = 1*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1 = eye(4);%Ԥ��Э�������
x_hat = [3,3,0.6,0]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
 % �۲����,�Ǹ��̶�ֵ
H=[0,0,1,0;
   0,0,0,1];

for k=2:len
   
    %%%%%%%%%%%%%%%%%%%           �����Ե������ֵ�EKF��        %%%%%%%%%%%%%%%%%%
    % 1 ״̬Ԥ��    
    ex_R = x_R(1) + x_R(3)*sin(x_R(4));
    ny_R = x_R(2) + x_R(3)*cos(x_R(4));
    s_R=x_R(3);
    f_R=x_R(4);
    x_forecast_R = [ex_R; ny_R; s_R; f_R];%Ԥ��ֵ
    % 2  �۲�Ԥ��
    y_yuce=H*x_forecast_R;
    %  ״̬����
    F_R = zeros(4,4);
    F_R (1,1) = 1; F_R (1,2) = 0; F_R (1,3) = sin(x_forecast_R(4)); F_R (1,4) = x_forecast_R(3)*cos(x_forecast_R(4));
    F_R (2,1) = 0; F_R (2,2) = 1; F_R (2,3)=cos(x_forecast_R(4)); F_R (2,4) = -x_forecast_R(3)*sin(x_forecast_R(4));
    F_R (3,1) = 0; F_R (3,2) = 0; F_R (3,3) = 1; F_R (3,4) = 0;
    F_R (4,1) = 0; F_R (4,2) = 0; F_R (4,3) = 0; F_R (4,4) = 1;    
    Pkk_1 = F_R*Pk*F_R'+Qk;%�ߵ���Ԥ��Э�������   
%     ���㿨��������
    Kk = Pkk_1*H'*(H*Pkk_1*H'+Rk)^-1; 
    %��ȡEKF����ֵ
    x_hat = x_forecast_R+Kk*(Z(k,:)'-y_yuce);%У��
    %����״̬�����Ĺ���Э�������
    Pk = (eye(4)-Kk*H)*Pkk_1;  
    
    
    %%%%%%%%%%%%%%%%%       ��UWB�͹��Ե����ںϲ��ֵ�EKF��      %%%%%%%%%%%%%%%%%%%%%%%%
    Pkk_R = F_R *P_R*F_R'+Qk;     %���ںϵ�Ԥ��Э�������
    
    %ʹ�ù��Ե����õ��ĵ�ǰλ��������������ƶ��ľ���  msd------------????????????��һ��ʱ�̵�λ��Ӧ�����ں��������λ��
    msd=sqrt((x_hat(1)-X_est_R_I_U(k-1,1))^2+(x_hat(2)-X_est_R_I_U(k-1,2))^2);
    %����ǰһ��ʱ�̻�վ���ƶ��ڵ�ľ���
    for g=1:6
        d_t_1(g)=sqrt((X_est_R_I_U(k-1,1)-bs(g,1))^2+(X_est_R_I_U(k-1,2)-bs(g,2))^2);%%---????��һ��ʱ�̵�λ��Ӧ�����ں��������λ��
    end
    %����в�
    residual=ones(6,1);
%     for g=1:6                          %-----�˴�������6����վ
% %       residual(g)=abs(msd-abs(d(k-1,g)-d(k,g))-Threshold)*k_r;   %Threshold=-1����  ------   k_rΪ�в����۲�����һ������ϵ��   
%         R_R_R(k,g)= msd-abs(d_t_1(g)-d(k,g));  
%         if(R_R_R(k,g)<-0.1) 
%             residual(g)=abs( R_R_R(k,g)+0.1)*100000000000;
%         end
%     end
    %�����ں�ʱ��Ҫ�Ĳ�����������
    de=diag([residual(1); residual(2); residual(3); residual(4); residual(5); residual(6); 1; 1]);%�ں������ľ���Ĳв�ϵ��
    R_E=R_F*de;   %----  �ں������ľ���
    %�������������Ÿ��Ⱦ���     ------��b_e,b_n����վ������
    HH_R(1,1)=(x_forecast_R(1)-x1(1))*((x1(1)-x_forecast_R(1))^2 +(x1(2)-x_forecast_R(1))^2)^(-0.5);
    HH_R(1,2)=(x_forecast_R(2)-x1(2))*((x1(1)-x_forecast_R(1))^2 +(x1(2)-x_forecast_R(1))^2)^(-0.5);
    
    HH_R(2,1)=(x_forecast_R(1)- x2(1))*((x_forecast_R(1)- x2(1))^2 +(x_forecast_R(1)-x2(2))^2)^(-0.5);
    HH_R(2,2)=(x_forecast_R(2)- x2(2))*((x_forecast_R(1)- x2(1))^2 +(x_forecast_R(1)-x2(2))^2)^(-0.5); 
    
    HH_R(3,1)=(x_forecast_R(1)- x3(1))*((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(1)- x3(2))^2)^(-0.5);
    HH_R(3,2)=(x_forecast_R(2)- x3(2))*((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(1)- x3(2))^2)^(-0.5);
    
    HH_R(4,1)=(x_forecast_R(1)- x4(1))*((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(1)- x4(2))^2)^(-0.5);
    HH_R(4,2)=(x_forecast_R(2)- x4(2))*((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(1)- x4(2))^2)^(-0.5);
    
    HH_R(5,1)=(x_forecast_R(1)- x5(1))*((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(1)- x5(2))^2)^(-0.5);
    HH_R(5,2)=(x_forecast_R(2)- x5(2))*((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(1)- x5(2))^2)^(-0.5);
    
    HH_R(6,1)=(x_forecast_R(1)- x6(1))*((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(1)- x6(2))^2)^(-0.5);
    HH_R(6,2)=(x_forecast_R(2)- x6(2))*((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(1)- x6(2))^2)^(-0.5); 
   
    HH_R(7,3)=1; 
    HH_R(8,4)=1; 
    
    %Ԥ��ֵ������ֵ
    y_R(1,1)=sqrt((x1(1)-  x_forecast_R(1))^2 +(x1(2)-x_forecast_R(2))^2);
    y_R(2,1)=sqrt((x_forecast_R(1)-  x2(1))^2 +(x_forecast_R(2)- x2(2))^2);
    y_R(3,1)=sqrt((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(2)- x3(2))^2);
    y_R(4,1)=sqrt((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(2)- x4(2))^2);
    y_R(5,1)=sqrt((x_forecast_R(1)-  x5(1))^2 +(x_forecast_R(2)- x5(2))^2);
    y_R(6,1)=sqrt((x_forecast_R(1)-  x6(1))^2 +(x_forecast_R(2)- x6(2))^2);
    y_R(7,1)=x_forecast_R(3);
    y_R(8,1)=x_forecast_R(4);
    
    %���㿨��������
    K_R = Pkk_R*HH_R'*(HH_R*Pkk_R*HH_R'+R_E)^-1; 
    %���Ź���ֵ
    x_R = x_forecast_R+K_R*(Z_R(k,:)'-y_R);%У��
    %����״̬�����Ĺ���Э�������
    P_R = (eye(4)-K_R*HH_R)*Pkk_R;  
    %���˲���������ھ����У��ںϺ�����Ź���ֵ
    X_est_R_I_U(k,:) = x_R';  
    
end



% %%�����в����ֵ
% figure;
% subplot(2,1,1);
% plot(R_R_R(:,1));
% subplot(2,1,2);
% plot(R_R_R(:,2));
% figure;
% subplot(2,1,1);
% plot(R_R_R(:,5));
% subplot(2,1,2);
% plot(R_R_R(:,6));
% %%%���������Ĳв����ֵ
% figure;
% subplot(2,1,1);
% scatter(R_UWB_3_U,R_R_R(R_UWB_3_U,3),'gO');
% hold on;
% plot(R_R_R(:,3));
% subplot(2,1,2);
% scatter(R_UWB_4_U,R_R_R(R_UWB_4_U,4),'gO');
% hold on;
% plot(R_R_R(:,4));


% % % ----�������߹����е���ʵ�켣
tx=3;
ty=3;
l=12;
w=12;
x=[tx,tx+l,tx+l,tx,tx];
y=[ty,ty,ty+w,ty+w,ty];
figure;
plot(x,y,'k','LineWidth',1.5);
hold on
%%%���Ե����Ĺ켣
% plot(X_est(:,1),X_est(:,2),'g-*','MarkerSize',8);
%%UBW��INS��NLOS����㷨
plot(X_est_R_I_U(:,1),X_est_R_I_U(:,2),'b-s','MarkerSize',8,'LineWidth',1.1);
%%%�������㷨�Ĺ켣
plot(X_est_R_I(:,1),X_est_R_I(:,2),'m-d','MarkerSize',9,'LineWidth',1.1);
%%%�Զ����㷨�Ĺ켣
plot(X_est_R(:,1),X_est_R(:,2),'g-*','MarkerSize',12,'LineWidth',1.1);
plot(1,1,'rs','MarkerFaceColor','r','MarkerSize',12);
plot(1,17,'rs','MarkerFaceColor','r','MarkerSize',12);
plot(9,17,'rs','MarkerFaceColor','r','MarkerSize',12);
plot(17,17,'rs','MarkerFaceColor','r','MarkerSize',12);
plot(17,1,'rs','MarkerFaceColor','r','MarkerSize',12);
plot(9,1,'rs','MarkerFaceColor','r','MarkerSize',12);
axis([0 19 0 19]);
xlabel('�������/m'); 
ylabel('�������/m');
legend('��ʵ�켣','˫��EKF��NLOS���','�����μ���㷨','˫��EKF��NLOS���','��վ');
hold off;
title('�켣ͼ');
%%����Ԥ��Э�������
RMSE_I_U=sqrt((sum((X_est_R_I_U(:,1)-P_P(:,1)).^2+(X_est_R_I_U(:,2)-P_P(:,2)).^2))/41);
RMSE_I=sqrt((sum((X_est_R_I(:,1)-P_P(:,1)).^2+(X_est_R_I(:,2)-P_P(:,2)).^2))/41);
RMSE_R_I=sqrt((sum((X_est_R(:,1)-P_P(:,1)).^2+(X_est_R(:,2)-P_P(:,2)).^2))/41);

RMSE_C=[RMSE_I_U RMSE_I RMSE_R_I];
% save('myData2.mat','RMSE_T');
load myData2;
% % 
RMSE=[RMSE_T;RMSE_C];
figure;
h=bar(RMSE,'BarWidth',0.5);

text(1.77,RMSE_C(1)+0.05,num2str(RMSE_C(1)+0.05),'VerticalAlignment','middle','HorizontalAlignment','center');
text(2,RMSE_C(2)+0.05,num2str(RMSE_C(2)),'VerticalAlignment','middle','HorizontalAlignment','center');
text(2.23,RMSE_C(3)+0.05,num2str(RMSE_C(3)+0.05),'VerticalAlignment','middle','HorizontalAlignment','center');

text(0.77,RMSE_T(1)+0.05,num2str(RMSE_T(1)+0.05),'VerticalAlignment','middle','HorizontalAlignment','center');
text(1,RMSE_T(2)+0.05,num2str(RMSE_T(2)),'VerticalAlignment','middle','HorizontalAlignment','center');
text(1.23,RMSE_T(3)+0.05,num2str(RMSE_T(3)+0.05),'VerticalAlignment','middle','HorizontalAlignment','center');    
    
   
set(h(1),'facecolor', 'b');
set(h(2),'facecolor', 'm');
set(h(3),'facecolor','g','EdgeColor','r','LineWidth',2);
legend('˫��EKF��NLOS���','�����μ���㷨','˫��EKF��NLOS���');
ylabel('λ��RMSE');
title('λ��RMSEͼ');


