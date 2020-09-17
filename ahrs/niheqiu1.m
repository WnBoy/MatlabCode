%%ԭʼ��������㷨
%�������������������
close all;
clc;
A = 300;     % x�����ϵ���뾶
B = 300;     % y�����ϵ���뾶
C = 300;     % z�����ϵ���뾶
x0 = -120;   %��������x����
y0 = -67;    %��������y����
z0 = 406;    %��������z����
SNR = 30;    %�����
 
num_alfa = 100;
num_sita = 50;
alfa = (0:num_alfa-1)*1*pi/num_alfa;
sita = (0:num_sita-1)*2*pi/num_sita;
x = zeros(num_alfa,num_sita);
y = zeros(num_alfa,num_sita);
z = zeros(num_alfa,num_sita);
for i = 1:num_alfa
    for j = 1:num_sita
        x(i,j) = x0 + A*sin(alfa(i))*cos(sita(j));
        y(i,j) = y0 + B*sin(alfa(i))*sin(sita(j));
        z(i,j) = z0 + C*cos(alfa(i));
    end
end
 
x = reshape(x,num_alfa*num_sita,1);    %ת����һά��������ں����Ĵ���
y = reshape(y,num_alfa*num_sita,1);
z = reshape(z,num_alfa*num_sita,1);
figure;
plot3(x,y,z,'*');
title('���ɵ�û������������������');
 
%�����ֵΪ0�ĸ�˹�ֲ����� 
amp = 10^(-SNR/20)*A;
x = x + amp*rand(num_alfa*num_sita,1);
y = y + amp*B/A*rand(num_alfa*num_sita,1);
z = z + amp*C/A*rand(num_alfa*num_sita,1);
figure;
plot3(x,y,z,'*');
string = ['�������������������ݣ�SNR=',num2str(SNR),'dB'];
title(string);
%% �ռ������������㷨
num_points = length(x);
%һ����ͳ��ƽ��
x_avr = sum(x)/num_points;
y_avr = sum(y)/num_points;
z_avr = sum(z)/num_points;
%������ͳ��ƽ��
xx_avr = sum(x.*x)/num_points;
yy_avr = sum(y.*y)/num_points;
zz_avr = sum(z.*z)/num_points;
xy_avr = sum(x.*y)/num_points;
xz_avr = sum(x.*z)/num_points;
yz_avr = sum(y.*z)/num_points;
%������ͳ��ƽ��
xxx_avr = sum(x.*x.*x)/num_points;
xxy_avr = sum(x.*x.*y)/num_points;
xxz_avr = sum(x.*x.*z)/num_points;
xyy_avr = sum(x.*y.*y)/num_points;
xzz_avr = sum(x.*z.*z)/num_points;
yyy_avr = sum(y.*y.*y)/num_points;
yyz_avr = sum(y.*y.*z)/num_points;
yzz_avr = sum(y.*z.*z)/num_points;
zzz_avr = sum(z.*z.*z)/num_points;
%�Ĵ���ͳ��ƽ��
yyyy_avr = sum(y.*y.*y.*y)/num_points;
zzzz_avr = sum(z.*z.*z.*z)/num_points;
xxyy_avr = sum(x.*x.*y.*y)/num_points;
xxzz_avr = sum(x.*x.*z.*z)/num_points;
yyzz_avr = sum(y.*y.*z.*z)/num_points;
 
%����������Է��̵�ϵ������
A0 = [yyyy_avr yyzz_avr xyy_avr yyy_avr yyz_avr yy_avr;
     yyzz_avr zzzz_avr xzz_avr yzz_avr zzz_avr zz_avr;
     xyy_avr  xzz_avr  xx_avr  xy_avr  xz_avr  x_avr;
     yyy_avr  yzz_avr  xy_avr  yy_avr  yz_avr  y_avr;
     yyz_avr  zzz_avr  xz_avr  yz_avr  zz_avr  z_avr;
     yy_avr   zz_avr   x_avr   y_avr   z_avr   1;];
%����������
b = [-xxyy_avr;
     -xxzz_avr;
     -xxx_avr;
     -xxy_avr;
     -xxz_avr;
     -xx_avr];
 
resoult = inv(A0)*b;
%resoult = solution_equations_n_yuan(A0,b);
 
x00 = -resoult(3)/2;                  %��ϳ���x����
y00 = -resoult(4)/(2*resoult(1));     %��ϳ���y����
z00 = -resoult(5)/(2*resoult(2));     %��ϳ���z����
 
AA = sqrt(x00*x00 + resoult(1)*y00*y00 + resoult(2)*z00*z00 - resoult(6));   % ��ϳ���x�����ϵ���뾶
BB = AA/sqrt(resoult(1));                                                    % ��ϳ���y�����ϵ���뾶
CC = AA/sqrt(resoult(2));                                                    % ��ϳ���z�����ϵ���뾶
 
x=x-x00;
y=y-y00;
z=z-z00;

xmin = min(x);
ymin = min(y);
zmin = min(z);
xmax = max(x);
ymax = max(y);
zmax = max(z);

xc = 0.5*(xmax+xmin);
yc = 0.5*(ymax+ymin);
zc = 0.5*(zmax+zmin);

y=y*(AA/BB);
z=z*(AA/CC);

%���Ϊ��
figure;
plot3(x,y,z,'*');
title('��������');

fprintf('��Ͻ��\n');
fprintf('a = %f, b = %f, c = %f, d = %f, e = %f, f = %f\n',resoult);
fprintf('x0 = %f, ������%f\n',x00,abs((x00-x0)/x0));
fprintf('y0 = %f, ������%f\n',y00,abs((y00-y0)/y0));
fprintf('z0 = %f, ������%f\n',z00,abs((z00-z0)/z0));
fprintf('A = %f,  ������%f\n',AA,abs((A-AA)/A));
fprintf('B = %f,  ������%f\n',BB,abs((B-BB)/B));
fprintf('C = %f,  ������%f\n',CC,abs((C-CC)/C));

