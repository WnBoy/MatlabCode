
clc;
clear all;
%%%%%%%%%%%%%%-------------����UWB��IMU�����ڶ�λ�ں��㷨--------------%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%===============���������㷨   ʵ��������С��Χ     ����ʹ����awg������===============%%%%%%%%%%%%%%%%%%%%%%%
%----1.ģ����Ե���������
%%%---1.1 6����վ������
x1=[1 1];
x2=[1 10];
x3=[5 10];
x4=[10 10];
x5=[10 1];
x6=[5 1];
bs=[x1;x2;x3;x4;x5;x6];
%%%---1.2 ������Ϣ
h=zeros(41,1);
for i=1:10
    h(i)=0;
    h(i+10)=90;
    h(i+20)=180;
    h(i+30)=270;
end
h(41)=270;
% % ������Ǽ�������
% figure;
% plot(h,'g');
% hold on;
h=awgn(h,-10);%������Ǽ����˹������
% plot(h,'r');

%�������Ϊ������
for i=1:41
   h(i)=(h(i)*pi)/180;
end
%%%--- 1.4 ���� 
N_P=41;
%%%--- 1.5 ����
N_S=zeros(41,1);
for i=1:41
    N_S(i)=0.6;
end
% figure;
% plot(N_S,'r');
% hold on;
N_S=awgn(N_S,30);%�����������˹������
% plot(N_S,'g');


%%%--- 1.6 ����λ��(2 2)


%ģ��ʵ�ʵ���������λ��
P_P=zeros(41,2);
P_P(1,1)=2;
P_P(1,2)=2;
for i=1:10
  P_P(i+1,1)=2;
  P_P(i+1,2)=0.6+P_P(i,2);
end
for i=12:21
   P_P(i,2)=8;
   P_P(i,1)=P_P(i-1,1)+0.6;
end
for i=22:31
   P_P(i,1)=8; 
   P_P(i,2)=P_P(i-1,2)-0.6;
end
for i=32:41
   P_P(i,1)=P_P(i-1,1)-0.6;
   P_P(i,2)=2;
end
% figure;
% plot(P_P(:,1),P_P(:,2));
%%%ģ��UWB�Ĳ�������
d_UWB_1=zeros(41,1);
for i=1:41
   d_UWB_1(i)= sqrt((P_P(i,1)-x1(1))^2+(P_P(i,2)-x1(2))^2);
end
d_UWB_2=zeros(41,1);
for i=1:41
   d_UWB_2(i)= sqrt((P_P(i,1)-x2(1))^2+(P_P(i,2)-x2(2))^2);
end
d_UWB_3=zeros(41,1);
for i=1:41
   d_UWB_3(i)= sqrt((P_P(i,1)-x3(1))^2+(P_P(i,2)-x3(2))^2);
end
d_UWB_4=zeros(41,1);
for i=1:41
   d_UWB_4(i)= sqrt((P_P(i,1)-x4(1))^2+(P_P(i,2)-x4(2))^2);
end
d_UWB_5=zeros(41,1);
for i=1:41
   d_UWB_5(i)= sqrt((P_P(i,1)-x5(1))^2+(P_P(i,2)-x5(2))^2);
end
d_UWB_6=zeros(41,1);
for i=1:41
   d_UWB_6(i)= sqrt((P_P(i,1)-x6(1))^2+(P_P(i,2)-x6(2))^2);
end
%%����UWB��������Ĵ�С
% figure;
% plot(d_UWB_1,'r');
% hold on;

%%%++++++++++++++++++++++++++++++������UWB�������ݼ����˹����
% Z_UWB_d_1=sqrt(0.0025).*randn(41,1);
% d_UWB_1=d_UWB_1+Z_UWB_d_1;
% Z_UWB_d_2=sqrt(0.0025).*randn(41,1);
% d_UWB_2=d_UWB_2+Z_UWB_d_2;
% Z_UWB_d_3=sqrt(0.0025).*randn(41,1);
% d_UWB_3=d_UWB_3+Z_UWB_d_3;
% Z_UWB_d_4=sqrt(0.0025).*randn(41,1);
% d_UWB_4=d_UWB_4+Z_UWB_d_4;
% Z_UWB_d_5=sqrt(0.0025).*randn(41,1);
% d_UWB_5=d_UWB_5+Z_UWB_d_5;
% Z_UWB_d_6=sqrt(0.0025).*randn(41,1);
% d_UWB_6=d_UWB_6+Z_UWB_d_6;
d_UWB_1=awgn(d_UWB_1,20);
d_UWB_2=awgn(d_UWB_2,20);
d_UWB_3=awgn(d_UWB_3,20);
d_UWB_4=awgn(d_UWB_4,20);
d_UWB_5=awgn(d_UWB_5,20);
d_UWB_6=awgn(d_UWB_6,20);

%���Լ��������Ժ��UWB��������Ĵ�С
% plot(d_UWB_1,'g');

%++++++++++++++++++++++++++++++++��3��4��վ�漴��������ƫ��(����ƫ���СΪ2m)
%��3��վ����30������ƫ��
R_UWB_3=randperm(40)+1;
R_UWB_3_U=R_UWB_3(1:30);
% figure;
% plot(d_UWB_3,'ro');
% hold on;
for i=1:30
   d_UWB_3(R_UWB_3_U(i))= d_UWB_3(R_UWB_3_U(i))+rand(1)+1.2;
end
% plot(d_UWB_3,'go','MarkerSize',13);
%��4��վ����30������ƫ��
R_UWB_4=randperm(40)+1;
R_UWB_4_U=R_UWB_4(1:30);
% figure;
% plot(d_UWB_4,'ro');
% hold on;
for i=1:30
   d_UWB_4(R_UWB_4_U(i))= d_UWB_4(R_UWB_4_U(i))+rand(1)+1.2;
end
% plot(d_UWB_4,'go','MarkerSize',13);

% %��6��վ����30������ƫ��
% R_UWB_6=randperm(40)+1;
% R_UWB_6_U=R_UWB_6(1:30);
% for i=1:30
%    d_UWB_6(R_UWB_6_U(i))= d_UWB_6(R_UWB_6_U(i))+rand(1)+0.6;
% end
% 
% %��1��վ����30������ƫ��
% R_UWB_1=randperm(40)+1;
% R_UWB_1_U=R_UWB_1(1:30);
% for i=1:30
%    d_UWB_1(R_UWB_1_U(i))= d_UWB_1(R_UWB_1_U(i))+rand(1)+0.6;
% end




%%%%%---------------------------�������Ե����㷨----------------------%%%%%%%%
len=N_P;%���沽��
X_est = zeros(len,4);%EKF����ֵ
X_est(1,:)=[2,2,0.6,0];
x_hat_P = [2,2,0.6,0]';
x_forecast = zeros(4,1);%Ԥ��ֵ

Qk_P = 0.5*diag([0.5; 0.5; 0.1; (5*pi)/180])^2;%��̬��������
Rk_P = 0.01*diag([0.1; (5*pi)/180])^2;%�۲���������       
Z_P=[N_S,h];  %���Ե����Ĳ���ֵ��һ������һ������
Pk_P = 1*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
Pkk_1_P = eye(4);%Ԥ��Э�������

 % �۲����,�Ǹ��̶�ֵ
H_P=[0,0,1,0;
    0,0,0,1];
for k=2:len
    % 1 ״̬Ԥ��    
    ex = x_hat_P(1) + x_hat_P(3)*sin(x_hat_P(4));
    ny = x_hat_P(2) + x_hat_P(3)*cos(x_hat_P(4));
    s=x_hat_P(3);
    f=x_hat_P(4);
    x_forecast = [ex; ny; s; f];%Ԥ��ֵ
    % 2  �۲�Ԥ��
    y_yuce=H_P*x_forecast;
    %  ״̬����
    F = zeros(4,4);
    F(1,1) = 1; F(1,2) = 0; F(1,3) = sin(x_forecast(4)); F(1,4) = x_forecast(3)*cos(x_forecast(4));
    F(2,1) = 0; F(2,2) = 1; F(2,3)=cos(x_forecast(4)); F(2,4) = -x_forecast(3)*sin(x_forecast(4));
    F(3,1) = 0; F(3,2) = 0; F(3,3) = 1; F(3,4) = 0;
    F(4,1) = 0; F(4,2) = 0; F(4,3) = 0; F(4,4) = 1;
    Pkk_1_P = F*Pk_P*F'+Qk_P;%�ߵ���Ԥ��Э�������   
%     ���㿨��������
    Kk = Pkk_1_P*H_P'*(H_P*Pkk_1_P*H_P'+Rk_P)^-1; 
    %��ȡEKF����ֵ
    x_hat_P = x_forecast+Kk*(Z_P(k,:)'-y_yuce);%У��
    %����״̬�����Ĺ���Э�������
    Pk_P = (eye(4)-Kk*H_P)*Pkk_1_P;  
    %���˲���������ھ�����
    X_est(k,:) = x_hat_P';  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%�����ں��㷨%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

              %%%%%%%%%%%%%%%%%%%%%%    ���ںϲ���EKF���ݵĳ�ʼ����    %%%%%%%%%%%%%%%%%%%%
               
% %����dΪ��n����ǩ����վ�ľ���  ---- ������6����վ
d=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,d_UWB_5,d_UWB_6];
% residual=zeros(6,1);
Z_R=[d_UWB_1,d_UWB_2,d_UWB_3,d_UWB_4,d_UWB_5,d_UWB_6,N_S,h]; %  -----  �ں�EKF�Ĳ���ֵ ��6�����룬һ��������һ������ n��8��
HH_R=zeros(8,4);
X_est_R = zeros(len,4);     %----  �ںϵ�EKF���Ź���ֵ
X_est_R(1,:)=[2,2,0.6,0];
P_R=1*eye(4);%����Э�������ĳ�ʼֵ
% P_R(4,4)=P_R(4,4)*40;
R_F = diag([0.5; 0.5; 0.5; 0.5; 0.5; 0.5; 0.1; (0.5*pi)/180])^2;  %���ںϡ��۲���������
x_R=[2,2,0.6,0]';%״̬�����ĳ�ʼֵ
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
x_hat = [2,2,0.6,0]';%״̬�����ĳ�ʼֵ[ex,ny,s,f]%%%%%%%%%%%%%%%%%%%%%%%��С����
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
    msd=sqrt((x_hat(1)-X_est_R(k-1,1))^2+(x_hat(2)-X_est_R(k-1,2))^2);
    %����ǰһ��ʱ�̻�վ���ƶ��ڵ�ľ���
    for g=1:6
        d_t_1(g)=sqrt((X_est_R(k-1,1)-bs(g,1))^2+(X_est_R(k-1,2)-bs(g,2))^2);%%---????��һ��ʱ�̵�λ��Ӧ�����ں��������λ��
    end
    %����в�
    residual=ones(6,1);
    for g=1:6                          %-----�˴�������6����վ
%       residual(g)=abs(msd-abs(d(k-1,g)-d(k,g))-Threshold)*k_r;   %Threshold=-1����  ------   k_rΪ�в����۲�����һ������ϵ��   
        R_R_R(k,g)= msd-abs(d_t_1(g)-d(k,g));  
        if(R_R_R(k,g)<-0.1) 
            residual(g)=abs( R_R_R(k,g))*1000000;
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
    X_est_R(k,:) = x_R';  
    
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


% %----�������߹����е���ʵ�켣
tx=2;
ty=2;
l=6;
w=6;
x=[tx,tx+l,tx+l,tx,tx];
y=[ty,ty,ty+w,ty+w,ty];
figure;
plot(x,y,'k','LineWidth',1.5);
hold on
%%%���Ե����Ĺ켣
plot(X_est(:,1),X_est(:,2),'g-*','MarkerSize',8);
%%%�ںϵĹ켣
plot(X_est_R(:,1),X_est_R(:,2),'m-x','MarkerSize',10);
plot(1,1,'bs','MarkerFaceColor',[0 0 1],'MarkerSize',12);
plot(1,10,'bs','MarkerFaceColor',[0 0 1],'MarkerSize',12);
plot(5,10,'bs','MarkerFaceColor',[0 0 1],'MarkerSize',12);
plot(10,10,'bs','MarkerFaceColor',[0 0 1],'MarkerSize',12);
plot(10,1,'bs','MarkerFaceColor',[0 0 1],'MarkerSize',12);
plot(5,1,'bs','MarkerFaceColor',[0 0 1],'MarkerSize',12);
axis([0 11 0 11]);
xlabel('�������/m'); 
ylabel('�������/m');
legend('��ʵ�켣','PDR','UWB+PDR','��վ');
hold off;


figure;
RMSE_I_U=sqrt((sum((X_est(:,1)-P_P(:,1)).^2+(X_est(:,2)-P_P(:,2)).^2))/41);
RMSE_I_U_R=sqrt((sum((X_est_R(:,1)-P_P(:,1)).^2+(X_est_R(:,2)-P_P(:,2)).^2))/41);
RMSE=[RMSE_I_U RMSE_I_U_R];
bar(RMSE,'BarWidth',0.2);
