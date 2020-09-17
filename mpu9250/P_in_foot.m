%%%%%%%%%%%%%%%%%%%%%
%����pdr����  V:1.0 [���ڽ��ϵ�]
%input��3����ٶȺͺ���Ƕ�
%output����������������һ���ĺ���
%%%%%%%%%%%%%%%%%%%%%


newData = importdata('./F3/4.tsv', '\t', 2);
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
g=1.0529;
%apsum��ȥ�����Ժ�ļ��ٶ�
apsum=asum-g;

figure; 
plot(apsum);
title('������ٶȵĺ�ȥ�������Ժ�ļ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2'); 

%���ٵ�ƽ���˲�
apsum_e=[];
 for i=1:m-14
     temp=sum(apsum(i:i+14,:))/15;  
     apsum_e = cat(1,apsum_e,temp);
 end
 
%  ����ƽ���˲�
 dir_p=[];
 for i=1:m-14
     tdirp=sum(data(i:i+14,10))/15;  
     dir_p = cat(1,dir_p,tdirp);
 end

%ƽ���˲�����к�����
[z,q]=size(apsum_e);

step=0;%����
sflag=0;%������ֵ���λ
status=1;%��ǰ״̬��1Ϊ����״̬��2Ϊ��ֵ״̬
i0=10;

for i=20:z-20
    
    if apsum_e(i)>0.05
        status=1;
    end
%�����ж�
    if status==2&&i-i0<10
        if apsum_e(i)<apsum_e(sflag(step+1))
            sflag(step+1)=i;           
        end
    end 

%stance���
    if apsum_e(i)<apsum_e(i+1)&&apsum_e(i)<apsum_e(i-1)
%         if apsum_e(i)>(-0.1)&&apsum_e(i)<0&&(apsum_e(i-15)>0.1||apsum_e(i+20)>0.1)&&i-i0>20       
        if apsum_e(i)<0.06&&(apsum_e(i-15)>0.15||apsum_e(i+15)>0.15)&&i-i0>20   
            i0=i;
            status=2;
            step=step+1;          
            sflag=[sflag i];
%             down=0; 
%             climbing=0;
        end
    end    
end
figure;
sflag=sflag(2:step+1);%��ֵ����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dir=0;%����
for t=1:step-1
    dirb=sflag(t);
    dire=sflag(t+1);
    dir=[dir,sum(dir_p(dirb:dire,:))/(dire-dirb+1)];%�����9���Ǻ����
end
dir=dir(2:step);%��������

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on;
scatter(sflag,apsum_e(sflag));
plot(apsum_e);
title('ƽ���˲���ĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');
legend('�����ж��ٽ��')
step


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�Զ��岽��Ϊ0.6m��ʵ��Ӧ����Ҫ����
plen=zeros(step-1,1);
for i=1:step-1
    plen(i)=1;
end
dir2=zeros(step-1,1);
for j=1:step-1
    dir2(j)=(-dir(j)*pi)/180;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    PDR��λ���� V��0.1
%%%%%%%%%%%%%%%%%%%%%%%%%%%    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Z=[plen dir2];
% pzero=100;%�������ƹ����е�������%%%%%%%%%%%%%%%%%%%%%%%%%��С����
len=step-1;%���沽��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%x_hatΪ״̬������x_hat=[ex,yn,s,f],eΪ�������꣬nΪ�������꣬sΪ������fΪ����
%����λ�����������We-N(0,1^2),Wn-N(0,1^2),��������Ws-N(0,0.1^2)(0.1m/s),���������ΪWf-N(0,5^2)(5��)
%Z=[plength dir]Ϊ����ֵ��plengthΪ������dirΪ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ekf �˲�
Qk = diag([1; 1; 0.1; (10*pi)/180])^2;%��̬��������
Rk = diag([0.1; (5*pi)/180])^2;%�۲���������

Pk = 5*eye(4);%����Э�������ĳ�ʼֵ��%%%%%%%%%%%%%%%%%%%%%%%��С����
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
%%ͼ��
figure;
plot(X_est(:,1),X_est(:,2), '*g');
xlabel('����'); 
ylabel('����'); 
title('EKF simulation');
legend('���߹켣');

