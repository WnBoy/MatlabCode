%%%%%%%%%%%%%%%%
%������ٶ����ݲ�����ƽ���˲������ٶ�Ԥ��������
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

%ƽ���˲�
apsum_e=[];
 for i=1:m-10
     temp=sum(apsum(i:i+10,:))/11;  
     apsum_e = cat(1,apsum_e,temp);
 end
 
figure; 
% subplot(2,1,1);
plot(apsum);
title('������ٶȵĺ�ȥ�������Ժ�ļ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');
% subplot(2,1,2);
figure; 
plot(apsum_e);
title('ƽ���˲����������ٶȵĺͼ��ٶ�');
xlabel('��λ��������');
ylabel('��λ��m/s2');

