
clc;
clear all;

%%%%%%%%%%%%%%-------------   ��ʵ��ʵ����롿    ����UWB��IMU�����ڶ�λ�ں��㷨--------------%%%%%%%%%%%%%%%%%

%----1.���Ե���������

%%%---1.1 4����վ������
x1=[9 10.8];
x2=[9 0.75];
x3=[3 0.75];
x4=[3 10.8];
bs=[x1;x2;x3;x4];

%%%---1.2 ������Ϣ
h=zeros(35,1);
for i=1:12
    h(i)=-180;
end
for i=13:22
    h(i)=-90;
end
for i=23:35
    h(i)=0;
end

% ������Ǽ�������
% figure;
% plot(h,'-*g');
% hold on;
h=awgn(h,-10);%������Ǽ����˹������
% plot(h,'-or');

%�������Ϊ������
for i=1:35
   h(i)=(h(i)*pi)/180;
end
%%%--- 1.4 ���� 
N_P=35;
%%%--- 1.5 ����
N_S=zeros(35,1);
for i=1:35
    N_S(i)=0.6;
end
% figure;
% plot(N_S,'-*g');
% hold on;
N_S=awgn(N_S,30);%�����������˹������
% plot(N_S,'-or');

%ʵ�ʵ���������
r_p=importdata('F:\Matlab\R2016\bin\UWB-IMU\TestData2\r_p.txt');
P_P=r_p;

%%% UWB�Ĳ������롾�ĸ���վ����ǩ�ľ��롿
data = importdata('F:\Matlab\R2016\bin\UWB-IMU\TestData2\r_x.txt');
%���㵼������ݵ�����(m)������(n)
[m, n]=size(data);

d_UWB_1=data(:,1);
d_UWB_2=data(:,2);
d_UWB_3=data(:,3);
d_UWB_4=data(:,4);

len=N_P;%���沽��
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���Զ��塿�����ں��㷨%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%%%%%    ���ںϲ���EKF���ݵĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%
               
% %����dΪ��n����ǩ����վ�ľ���  ---- ��4����վ
d=data;
residual=zeros(4,1);
Z_R=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,N_S,h]; %  -----  �ں�EKF�Ĳ���ֵ ��6�����룬һ��������һ������ n��8��
HH_R=zeros(6,4);
X_est_R = zeros(len,4);     %----  �ںϵ�EKF���Ź���ֵ
X_est_R(1,:)=[9,10.2,0.6,(-180)*pi/180];
P_R=0.1*eye(4);%����Э�������ĳ�ʼֵ
P_R(4,4)=P_R(4,4)*40;
R_F = diag([0.5; 0.5; 0.5; 0.5; 0.1; (0.1*pi)/180])^2;  %���ںϡ��۲���������
x_R=[9,10.2,0.6,(-180)*pi/180]';%״̬�����ĳ�ʼֵ
% R_R_R=zeros(len,4);
% d_t_1=zeros(4,1);
Threshold=0.4; %%%%-----NLOS���

%%%%%%%%%%%%%%%%%%%%%%%%%%%%       �����Ե�����EKF�ĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���Ե���ʹ��ekf �ó���ǰλ��
Qk = 0.5*diag([0.5; 0.5; 0.1; (5*pi)/180])^2;%Ԥ����������
Rk = 0.01*diag([0.1; (5*pi)/180])^2;%������������       
Z=[N_S,h];  %���Ե����Ĳ���ֵ��һ������һ������
Pk = 2*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1 = eye(4);%Ԥ��Э�������
x_hat = [9,10.2,0.6,(-180)*pi/180]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
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
     
    HH_R(5,3)=1; 
    HH_R(6,4)=1; 
    
    %Ԥ��ֵ������ֵ
    y_R(1,1)=sqrt((x1(1)-  x_forecast_R(1))^2 +(x1(2)-x_forecast_R(2))^2);
    y_R(2,1)=sqrt((x_forecast_R(1)-  x2(1))^2 +(x_forecast_R(2)- x2(2))^2);
    y_R(3,1)=sqrt((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(2)- x3(2))^2);
    y_R(4,1)=sqrt((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(2)- x4(2))^2);
    y_R(5,1)=x_forecast_R(3);
    y_R(6,1)=x_forecast_R(4);
    
    %%%�ѵ�ǰʱ�̵Ĺ��Ե�����λ�ù���ֵת��Ϊ   ����ֵ
    y_R_F(1,1)=sqrt((x1(1)-  x_hat(1))^2 +(x1(2)-x_hat(2))^2);
    y_R_F(2,1)=sqrt((x_hat(1)-  x2(1))^2 +(x_hat(2)- x2(2))^2);
    y_R_F(3,1)=sqrt((x_hat(1)-  x3(1))^2 +(x_hat(2)- x3(2))^2);
    y_R_F(4,1)=sqrt((x_hat(1)-  x4(1))^2 +(x_hat(2)- x4(2))^2);
    
    %%%---NLOS���---%%%  
    r_d=abs(d(k,:)' - y_R_F);
    residual=ones(4,1);
    for i=1:4
        if(r_d(i)>Threshold)
            Temp=r_d(i)-Threshold;
            residual(i)=Temp*10000;  %%����в�
        end
    end
    de=diag([residual(1); residual(2); residual(3); residual(4); 1; 1]);%�ں������ľ���Ĳв�ϵ��
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
% figure;
% %�����Զ����㷨��Ч��
% plot(X_est_R(:,1),X_est_R(:,2),'g-*','MarkerSize',12,'LineWidth',1.1);




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ں��㷨�������Ρ�%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%%%%%    ���ںϲ���EKF���ݵĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%
               
% %����dΪ��n����ǩ����վ�ľ���  ---- ��4����վ
d=data;
% residual=zeros(6,1);
Z_R=[d_UWB_1, d_UWB_2, d_UWB_3, d_UWB_4, N_S, h]; %  -----  �ں�EKF�Ĳ���ֵ ��4�����룬һ��������һ������ 
HH_R=zeros(6,4);
X_est_R_I = zeros(len,4);     %----  �ںϵ�EKF���Ź���ֵ
X_est_R_I(1,:)=[9, 10.2, 0.6, (-180)*pi/180];
P_R=1*eye(4);%����Э�������ĳ�ʼֵ
% P_R(4,4)=P_R(4,4)*40;
R_F = diag([0.5; 0.5; 0.5; 0.5; 0.1; (6*pi)/180])^2;  %���ںϡ��۲���������
x_R=[9,10.2,0.6,(-180)*pi/180]';%״̬�����ĳ�ʼֵ
R_R_R=zeros(len, 4);
d_t_1=zeros(4, 1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%       �����Ե�����EKF�ĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���Ե���ʹ��ekf �ó���ǰλ��
Qk = 0.5*diag([0.5; 0.5; 0.1; (5*pi)/180])^2;%��̬��������
Rk = 0.01*diag([0.1; (5*pi)/180])^2;%�۲���������       
Z=[N_S,h];  %���Ե����Ĳ���ֵ��һ������һ������
Pk = 1*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1 = eye(4);%Ԥ��Э�������
x_hat = [9, 10.2, 0.6, (-180)*pi/180]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
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
    for g=1:4
        d_t_1(g)=sqrt((X_est_R_I(k-1,1)-bs(g,1))^2+(X_est_R_I(k-1,2)-bs(g,2))^2);%%---????��һ��ʱ�̵�λ��Ӧ�����ں��������λ��
    end
    %����в�
    residual=ones(4,1);
    for g=1:4                          %-----�˴�������4����վ
%       residual(g)=abs(msd-abs(d(k-1,g)-d(k,g))-Threshold)*k_r;   %Threshold=-1����  ------   k_rΪ�в����۲�����һ������ϵ��   
        R_R_R(k,g)= msd-abs(d_t_1(g)-d(k,g));  
        if(R_R_R(k,g)<0.3) 
            residual(g)=1000000*abs(R_R_R(k,g));
        end
    end
    %�����ں�ʱ��Ҫ�Ĳ�����������
    de=diag([residual(1); residual(2); residual(3); residual(4); 1; 1]);%�ں������ľ���Ĳв�ϵ��
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
       
    HH_R(5,3)=1; 
    HH_R(6,4)=1; 
    
    %Ԥ��ֵ������ֵ
    y_R(1,1)=sqrt((x1(1)-  x_forecast_R(1))^2 +(x1(2)-x_forecast_R(2))^2);
    y_R(2,1)=sqrt((x_forecast_R(1)-  x2(1))^2 +(x_forecast_R(2)- x2(2))^2);
    y_R(3,1)=sqrt((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(2)- x3(2))^2);
    y_R(4,1)=sqrt((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(2)- x4(2))^2);
    y_R(5,1)=x_forecast_R(3);
    y_R(6,1)=x_forecast_R(4);
    
    %���㿨��������
    K_R = Pkk_R*HH_R'*(HH_R*Pkk_R*HH_R'+R_E)^-1; 
    %���Ź���ֵ
    x_R = x_forecast_R+K_R*(Z_R(k,:)'-y_R);%У��
    %����״̬�����Ĺ���Э�������
    P_R = (eye(4)-K_R*HH_R)*Pkk_R;  
    %���˲���������ھ����У��ںϺ�����Ź���ֵ
    X_est_R_I(k,:) = x_R';  
    
end

% figure;
% plot(X_est_R_I(:,1),X_est_R_I(:,2),'m-d','MarkerSize',9,'LineWidth',1.1);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ں��㷨��UWB��INS��NLOS����㷨��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%%%%%    ���ںϲ���EKF���ݵĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%
               
% %����dΪ��n����ǩ����վ�ľ���  ---- ������4����վ
d=data;
% residual=zeros(6,1);
Z_R=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,N_S,h]; %  -----  �ں�EKF�Ĳ���ֵ ��6�����룬һ��������һ������ n��8��
HH_R=zeros(6,4);
X_est_R_I_U = zeros(len,4);     %----  �ںϵ�EKF���Ź���ֵ
X_est_R_I_U(1,:)=[9, 10.2, 0.6, (-180)*pi/180];
P_R=1*eye(4);%����Э�������ĳ�ʼֵ
% P_R(4,4)=P_R(4,4)*40;
R_F = diag([0.5; 0.5; 0.5; 0.5; 0.1; (0.5*pi)/180])^2;  %���ںϡ��۲���������
x_R=[9, 10.2, 0.6, (-180)*pi/180]';%״̬�����ĳ�ʼֵ
R_R_R=zeros(len,4);
d_t_1=zeros(4,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%       �����Ե�����EKF�ĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���Ե���ʹ��ekf �ó���ǰλ��
Qk = 0.5*diag([0.5; 0.5; 0.1; (5*pi)/180])^2;%��̬��������
Rk = 0.01*diag([0.1; (5*pi)/180])^2;%�۲���������       
Z=[N_S,h];  %���Ե����Ĳ���ֵ��һ������һ������
Pk = 1*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1 = eye(4);%Ԥ��Э�������
x_hat = [9, 10.2, 0.6, (-180)*pi/180]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
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
    
    R_E=R_F;   %----  �ں������ľ���
    %�������������Ÿ��Ⱦ���     ------��b_e,b_n����վ������
    HH_R(1,1)=(x_forecast_R(1)-x1(1))*((x1(1)-x_forecast_R(1))^2 +(x1(2)-x_forecast_R(1))^2)^(-0.5);
    HH_R(1,2)=(x_forecast_R(2)-x1(2))*((x1(1)-x_forecast_R(1))^2 +(x1(2)-x_forecast_R(1))^2)^(-0.5);
    
    HH_R(2,1)=(x_forecast_R(1)- x2(1))*((x_forecast_R(1)- x2(1))^2 +(x_forecast_R(1)-x2(2))^2)^(-0.5);
    HH_R(2,2)=(x_forecast_R(2)- x2(2))*((x_forecast_R(1)- x2(1))^2 +(x_forecast_R(1)-x2(2))^2)^(-0.5); 
    
    HH_R(3,1)=(x_forecast_R(1)- x3(1))*((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(1)- x3(2))^2)^(-0.5);
    HH_R(3,2)=(x_forecast_R(2)- x3(2))*((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(1)- x3(2))^2)^(-0.5);
    
    HH_R(4,1)=(x_forecast_R(1)- x4(1))*((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(1)- x4(2))^2)^(-0.5);
    HH_R(4,2)=(x_forecast_R(2)- x4(2))*((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(1)- x4(2))^2)^(-0.5);
    
    HH_R(5,3)=1; 
    HH_R(6,4)=1; 
    
    %Ԥ��ֵ������ֵ
    y_R(1,1)=sqrt((x1(1)-  x_forecast_R(1))^2 +(x1(2)-x_forecast_R(2))^2);
    y_R(2,1)=sqrt((x_forecast_R(1)-  x2(1))^2 +(x_forecast_R(2)- x2(2))^2);
    y_R(3,1)=sqrt((x_forecast_R(1)-  x3(1))^2 +(x_forecast_R(2)- x3(2))^2);
    y_R(4,1)=sqrt((x_forecast_R(1)-  x4(1))^2 +(x_forecast_R(2)- x4(2))^2);
    y_R(5,1)=x_forecast_R(3);
    y_R(6,1)=x_forecast_R(4);
    
    %���㿨��������
    K_R = Pkk_R*HH_R'*(HH_R*Pkk_R*HH_R'+R_E)^-1; 
    %���Ź���ֵ
    x_R = x_forecast_R+K_R*(Z_R(k,:)'-y_R);%У��
    %����״̬�����Ĺ���Э�������
    P_R = (eye(4)-K_R*HH_R)*Pkk_R;  
    %���˲���������ھ����У��ںϺ�����Ź���ֵ
    X_est_R_I_U(k,:) = x_R';  
    
end

% figure;
% plot(X_est_R_I_U(:,1),X_est_R_I_U(:,2),'b-s','MarkerSize',8,'LineWidth',1.1);
%%

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
tx=9;
ty=10.2;
l=6;
w=7.2;
x=[tx,tx,tx-l,tx-l];
y=[ty,ty-w,ty-w,ty];
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
plot(9,10.8,'rs','MarkerFaceColor','r','MarkerSize',12);
plot(9,0.75,'rs','MarkerFaceColor','r','MarkerSize',12);
plot(3,0.75,'rs','MarkerFaceColor','r','MarkerSize',12);
plot(3,10.8,'rs','MarkerFaceColor','r','MarkerSize',12);
axis([2 10 0 11.5]);
xlabel('�������/m'); 
ylabel('�������/m');
% legend('��ʵ�켣','˫��EKF��NLOS���','�����μ���㷨','˫��EKF��NLOS���','��վ');
legend('��ʵ�켣','˫��EKF��NLOS���','�����μ���㷨','˫��EKF��NLOS���');
hold off;
title('�켣ͼ');

%%����Ԥ��Э�������
RMSE_I_U=sqrt((sum((X_est_R_I_U(:,1)-P_P(:,1)).^2+(X_est_R_I_U(:,2)-P_P(:,2)).^2))/41);
RMSE_I=sqrt((sum((X_est_R_I(:,1)-P_P(:,1)).^2+(X_est_R_I(:,2)-P_P(:,2)).^2))/41);
RMSE_R_I=sqrt((sum((X_est_R(:,1)-P_P(:,1)).^2+(X_est_R(:,2)-P_P(:,2)).^2))/41);




