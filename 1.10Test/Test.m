clc;
clear all;

%���Ե�������
newData = importdata('3.txt', '\t', 2);
data=newData.data;
ax=data(:,1);
ay=data(:,2);
az=data(:,3);
Angle=data(:,9);
%���ٶȷ�ֵ
a=sqrt(ax.^2+ay.^2+az.^2);
%��ֵ
meanAx=mean(ax);
meanAy=mean(ay);
meanAz=mean(az);
meanA=mean(a);
meanAngle=mean(Angle);
%����
axS=S(ax,meanAx);
ayS=S(ay,meanAy);
azS=S(az,meanAz);
aS=S(a,meanA);
AngleS=S(Angle,meanAngle);

figure;
subplot(4,1,1);
plot(ax);xlabel('������');ylabel('���ٶ�/g');title('x����ٶ�');
subplot(4,1,2);
plot(ay);xlabel('������');ylabel('���ٶ�/g');title('y����ٶ�');
subplot(4,1,3);
plot(az);xlabel('������');ylabel('���ٶ�/g');title('z����ٶ�');
subplot(4,1,4);
plot(a);xlabel('������');ylabel('���ٶ�/g');title('���ٶȷ�ֵ');
% subplot(5,1,5);
figure;
plot(Angle);xlabel('������');ylabel('�Ƕ�/��');title('�����');
axis([0 200 77.2 77.5]);

