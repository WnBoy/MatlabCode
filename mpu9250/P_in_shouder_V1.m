%%%%%%%%%%%%%%%%%%%%%
%����pdr����  V:1.0--[�ŵ�����ϵ�]
%input��3����ٶȺͺ���Ƕ�
%output����������������һ���ĺ���
%%%%%%%%%%%%%%%%%%%%%

%1.��������
newData = importdata('./G/G6.tsv', '\t', 2);
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
g=1.02649;
%apsum��ȥ�����Ժ�ļ��ٶ�
apsum=asum-g;

% figure; 
% plot(apsum);
% title('������ٶȵĺ�ȥ�������Ժ�ļ��ٶ�');
% xlabel('��λ��������');
% ylabel('��λ��m/s2'); 

%���ٵ�ƽ���˲�
apsum_e=[];
 for i=1:m-10
     temp=sum(apsum(i:i+10,:))/11;  
     apsum_e = cat(1,apsum_e,temp);
 end
%����ƽ���˲�
 dir_p=[];
 for i=1:m-10
     tdirp=sum(data(i:i+10,7))/11;  
     dir_p = cat(1,dir_p,tdirp);
 end
 
 
 %ƽ���˲�����к�����
 [z,q]=size(apsum_e);

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
max=-0.1;%һ���еļ��ٶ����ֵ
step=0;%����
sflag=0;%������ֵ���λ
climbing=0;%�������
status=1;%��ǰ״̬��1Ϊ����״̬��2Ϊ��ֵ״̬
down=0;%�½����

for i=2:z-1
    if apsum_e(i)>max
        max=apsum_e(i);
    end
    if apsum_e(i)<min
        min=apsum_e(i);
    end
    if apsum_e(i)>apsum_e(i-1)
        climbing=climbing+1;
    end
    if apsum_e(i)<apsum_e(i-1)
        down=down+1;
    end
    if down>10
        status=1;
    end
    if status==2&&i-i0<8
        if apsum_e(i)>apsum_e(sflag(step+1))
            sflag(step+1)=i;
            pmax=apsum_e(i);
        end
    end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%     ��㽻��  
    if pflag==1&&apsum_e(tflag+8)<0.025
        pflag=0; 
    end

    if pflag==1&&apsum_e(i)>apsum_e(i-1)
        pclimbing=pclimbing+1;
    end
       
    %�����ж�һ���Ŀ�ʼ�����
    if pflag==1&&pclimbing>5&&apsum_e(tflag+pclimbing)>0.015
        pb=[pb tflag];%һ����ʼ��ʱ�� 
        ptemp=k*(pmax-min)^(1/4);%��ȡ����
        plength=[plength ptemp];%��������
        pflag=0; 
        pzero=pzero+1;
    end
    
    if apsum_e(i)>0&&apsum_e(i-1)<0
        tflag=i;%���µ�ǰ�����ʱ��
        pflag=1;%���Ϊ���Ŀ�ʼ
        pclimbing=0;%���Ŀ�ʼ�Ժ��������ĵ���      
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ֵ���
    if apsum_e(i)>apsum_e(i+1)&&apsum_e(i)>apsum_e(i-1)
%         if max>0.045&&climbing>10&&apsum_e(i)>0.04
        if apsum_e(i)>0.045&&climbing>8
            i0=i;
            pmax=apsum_e(i);
            status=2;
            step=step+1;          
%             max=min;
            min=apsum_e(i);
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
    dir=[dir,sum(dir_p(dirb:dire,:))/(dire-dirb+1)];%�����9���Ǻ����
end
dir=dir(2:pzero);%��������
dir=[dir dir(pzero-1)]';%���һ���ķ������һ�η���һ��

plength=plength(3:pzero+1);%�������飬��һ���Ĳ�������Ҫ��Ҫ����
plength=[plength plength(pzero-1)]';%���һ����������һ��һ��
%���һ������������޷�̽�⵽�����������һ���Ĳ���������һ����
%���һ���ķ��������һ����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hold on;
scatter(sflag,apsum_e(sflag));
scatter(pb,apsum_e(pb));
plot(apsum_e);
title('ƽ���˲���ĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');
legend('�����ж��ٽ��')
pzero
step


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�Զ��岽��Ϊ0.6m��ʵ��Ӧ����Ҫ����
plen=zeros(pzero,1);
for i=1:pzero
    plen(i)=0.6;
end
dir2=zeros(pzero,1);
for j=1:pzero
    dir2(j)=(-dir(j)*pi)/180;
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

