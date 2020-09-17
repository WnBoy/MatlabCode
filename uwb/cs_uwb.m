%1-D�ź�ѹ�����е�ʵ�֣�����ƥ��׷�ٷ�OMP��
%ʱ������ź�����
K=15;              %ϡ��ȣ���FFT���Կ�������
N=500;            %�źų���
M=100;             %������(M>=K*log(N/K))
Tp = 1e-8;           %����ʱ����
Nc = 8;           %���Ҳ����ڸ���
A = 1;               %�������
f = Nc / Tp;            %Ƶ��
x = sin(2.*pi.*f.*linspace(0,Tp,N));   %UWB�ź�
Phi=randn(M,N);                      %�۲����
s=Phi*x.';                           
m=2*K;
Psi=fft(eye(N,N))/sqrt(N);
T=Phi*Psi';
hat_y=zeros(1,N);
Aug_t=[];
r_n=s;
for times=1:m
    for col=1:N
        product(col)=abs(T(:,col)'*r_n);
    end
    [val,pos]=max(product);
    Aug_t=[Aug_t,T(:,pos)];
    T(:,pos)=zeros(M,1);
    aug_y=(Aug_t'*Aug_t)^(-1)*Aug_t'*s;
    r_n=s-Aug_t*aug_y;
    pos_array(times)=pos;            
end
hat_y(pos_array)=aug_y;             %�ع�����������
hat_x=real(Psi'*hat_y.');          %���渵��Ҷ�任�ع��õ���ʱ���ź�
subplot(211)
plot(hat_x,'k.-')                 %�ؽ��ź�
ylim([-1 1]);
title('�ָ������ź�x');
subplot(212)
plot(x,'r')                      %ԭʼ�ź�
title('ԭ�ź�x');
norm(hat_x.'-x)/norm(x)             %�ع����