%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����������ԭ�ź�
% ԭ�źű�����numbis��Ϊ����
function [bits]=bit(numbits)
bits=rand(1,numbits)>0.5;
%rand����������0��1�Ͼ��ȷֲ��������
%��Щ��>0.5�ļ��ʸ���һ�룬��bisΪ0��1�ļ��ʸ���
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �����ظ�����  % 'Ns' ����Ԫ�ظ���
function [repbits]=repcode(bits,Ns)
numbits = length(bits);
temprect=ones(1,Ns);
temp1=zeros(1,numbits*Ns);
temp1(1:Ns:1+Ns*(numbits-1))=bits;
temp2=conv(temp1,temprect);
repbits=temp2(1:Ns*numbits);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����TH�벢����PPM���� 
% �������£�
% 'seq'��������Դ��
% 'fc' ������Ƶ��
% 'Tc' ��ʱ϶����
% 'Ts' ������ƽ���ظ�����
% 'dPPM'��PPM�����ʱ��
% 'THcode' ��TH��
% �������������
% '2PPMTHseq' ��TH��PPM��ͬ�����ź�
% 'THseq' ��δ��PPM���Ƶ��ź�
function [PPMTHseq,THseq] = PPM_TH(seq,fc,Tc,Ts,dPPM,THcode)
% ����
dt = 1 ./ fc;                   
framesamples = floor(Ts./dt);   %ÿ�������������                               
chipsamples = floor (Tc./dt);                                  
PPMsamples = floor (dPPM./dt);                                 
THp = length(THcode);           

totlength = framesamples*length(seq);
PPMTHseq=zeros(1,totlength);
THseq=zeros(1,totlength);

% ����TH���PPM  %s(t)=sum(p(t-jTs-CjTc-aE))
for k = 1 : length(seq)
        % ����λ��,��ʾ�ڼ�������-jTs
    index = 1 + (k-1)*framesamples;
        % ����TH��,-CjTc����ʾ�ڼ���ʱ϶
    kTH = THcode(1+mod(k-1,THp));
    index = index + kTH*chipsamples;
        THseq(index) = 1;
    
    % ����PPMʱ��,-aE����ʾ��ʱ϶�ڵ�λ��
    index = index + PPMsamples*seq(k);
    PPMTHseq(index) = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ����TH��
% Np:��ʱ������
% Nh:��ʱ������Ͻ�
function [THcode]=TH(Nh,Np)
THcode = floor(rand(1,Np).*Nh);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����UWB�ź�
% �����������£�
% Pow:���书��
% fc;����Ƶ��
% numbits���źű�����
% Ns��ÿ����������
% Np:��ʱ������
% Nh:��ʱ������Ͻ�
% Ts�������ظ�����.
% Tc��ʱ϶��С
% Tm:�������ʱ��
% tau�������������
% dPPM��PPM����ʱ��
% ����ֵ��
% bits:����������
% THcode:TH��
% Stx�������ź�
% ref��δ�����ƵĲ����ź�

function [bits,THcode,Stx,ref]=transmitter_2PPM_TH(fc,numbit,Ns,Ts,dPPM)
% �������
Pow = -30;       
numbits = numbit;  
Tc = 1e-9;       
Nh = 10;         
Np = 5;        
Tm = 0.5e-9;   
tau = 0.2e-9;   
G = 1;
% ģ�ⷢ�䲽��
% ������ԭ�ź�
bits = bit(numbits);
repbits = repcode(bits,Ns);  % �ظ�����
THcode = TH(Nh,Np); % ����TH��
[PPMTHseq,THseq] = PPM_TH(repbits,fc,Tc,Ts,dPPM,THcode); % ����
% �����˲�
power = (10^(Pow/10))/1000;                                    
Ex = power * Ts;                
w0 = waveform(fc,Tm,tau);                                
wtx = w0 .* sqrt(Ex);           
Sa = conv(PPMTHseq,wtx);                                       
Sb = conv(THseq,wtx);         
                              
% ��������ź�
L = floor((Ts*fc))*Ns*numbits;
Stx = Sa(1:L);
ref = Sb(1:L);

if G   %��ͼ
F = figure(1);
set(F,'Position',[30 120 700 400]);
cla
tmax = numbits*Ns*Ts;
time = linspace(0,tmax,length(Stx));
P = plot(time,Stx);
set(P,'LineWidth',2);
ylow=-1.5*abs(min(wtx));
yhigh=1.5*max(wtx);
axis([0 tmax ylow yhigh]);
AX=gca;
set(AX,'FontSize',12);
X=xlabel('ʱ�� [s]');
set(X,'FontSize',14);
Y=ylabel('���� [V]');
set(Y,'FontSize',14);
for j = 1 : numbits
    tj = (j-1)*Ns*Ts;
    L1=line([tj tj],[ylow yhigh]);
    set(L1,'Color',[0 0 0],'LineStyle', ...%������ص���
       '--','LineWidth',2);
    for k = 0 : Ns-1
        if k > 0
            tn = tj + k*Nh*Tc;
            L2=line([tn tn],[ylow yhigh]);
            set(L2,'Color',[0.5 0.5 0.5],'LineStyle', ...%���֡����
               '-.','LineWidth',2);
        end
        for q = 1 : Nh-1
            th = tj + k*Nh*Tc + q*Tc;
            L3=line([th th],[0.8*ylow 0.8*yhigh]);
            set(L3,'Color',[0.5 0.5 0.5],'LineStyle', ...
               ':','LineWidth',1);                       %���ʱ϶����
        end
    end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%