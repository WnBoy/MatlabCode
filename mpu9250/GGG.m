%���������ٶȵĳ���

newData = importdata('gp.tsv', '\t', 2);
data=newData.data;
asum=sqrt(data(:,2).^2+data(:,3).^2+data(:,4).^2);
g=sum(asum)/503;
g