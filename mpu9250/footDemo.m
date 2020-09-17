%���ٶȲ���Ԥ�������
%����pdr���� [���ڽ��ϵ�]

newData = importdata('./F4/5.tsv', '\t', 2);
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
apsum_e1=[];
 for i=1:m-10
     temp1=sum(apsum(i:i+10,:))/11;  
     apsum_e1 = cat(1,apsum_e1,temp1);
 end
 
 [M,N]=size(apsum_e1);
 apsum_e2=[];
 for i=1:M-4
     temp2=sum(apsum_e1(i:i+4,:))/5;  
     apsum_e2 = cat(1,apsum_e2,temp2);
 end
 
 
%  ����ƽ���˲�
 dir_p=[];
 for i=1:m-14
     tdirp=sum(data(i:i+14,10))/15;  
     dir_p = cat(1,dir_p,tdirp);
 end

%ƽ���˲�����к�����
[z,q]=size(apsum_e2);

step=0;%����
sflag=0;%������ֵ���λ
status=1;%��ǰ״̬��1Ϊ����״̬��2Ϊ��ֵ״̬
i0=10;

for i=20:z-20
    
    if apsum_e2(i)>0.05
        status=1;
    end
%�����ж�
    if status==2&&i-i0<10
        if apsum_e2(i)<apsum_e2(sflag(step+1))
            sflag(step+1)=i;           
        end
    end 

%stance���
    if apsum_e2(i)<apsum_e2(i+1)&&apsum_e2(i)<apsum_e2(i-1)
%         if apsum_e(i)>(-0.1)&&apsum_e(i)<0&&(apsum_e(i-15)>0.1||apsum_e(i+20)>0.1)&&i-i0>20       
        if apsum_e2(i)<0.06&&(apsum_e2(i-15)>0.15||apsum_e2(i+15)>0.15)&&i-i0>20   
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
scatter(sflag,apsum_e2(sflag));
plot(apsum_e2);
title('ƽ���˲���ĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');
legend('�����ж��ٽ��')
step
