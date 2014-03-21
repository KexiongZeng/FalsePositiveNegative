clear;
close all;
pa=parameter;
SpoofRange=pa.SpoofRange;
 Accuracy=zeros(5,10);
%Accuracy=zeros(1,15);
MaxFalsePositive=zeros(1,15);
%InitialAnchorRatio=pa.InitialAnchorRatio;
% for i=1:15
%  SUNumber=100*i;
%  InitialAnchorRatio=0.01;
%  BeaconRange=10;
%  filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
% tmp=load(filename);
% Warn=tmp.Warn;
% Accuracy(i)=sum(Warn)/100;
% % FalsePositive=tmp.FalsePositive;
% % a=find(Warn);
% % b=FalsePositive(a);
% % MaxFalsePositive(i)=max(b);
% end
% 
% figure(1)
% plot(100:100:1500,Accuracy(1,1:15));
% grid on;
% hold on;
% ylim([0,1]);

for i=1:5
         InitialAnchorRatio=0.1;
             BeaconRange=i;
    for j=1:10
     SUNumber=100*j;
     filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
     tmp=load(filename);
     Warn=tmp.Warn;
     Accuracy(i,j)=sum(Warn)/100;
    end
end

Density=100:100:1000;
R=100:100:500;
figure(1)
%h1=mesh(Density,R,Accuracy);
h1=surf(Density,R,Accuracy);
%set(h1,'facealpha',0.3);
%plot(100:100:1500,Accuracy(1,1:15),'yellow');
%hold on;

for i=1:5
         InitialAnchorRatio=0.3;
             BeaconRange=i;
    for j=1:10
     SUNumber=100*j;
     filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
     tmp=load(filename);
     Warn=tmp.Warn;
     Accuracy(i,j)=sum(Warn)/100;
    end
end

Density=100:100:1000;
R=100:100:500;
figure(2)
%h2=mesh(Density,R,Accuracy);
h2=surf(Density,R,Accuracy);
%set(h2,'facealpha',0.5);
%plot(100:100:1500,Accuracy(1,1:15),'yellow');
%hold on;


for i=1:5
         InitialAnchorRatio=0.4;
             BeaconRange=i;
    for j=1:10
     SUNumber=100*j;
     filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
     tmp=load(filename);
     Warn=tmp.Warn;
     Accuracy(i,j)=sum(Warn)/100;
    end
end

Density=100:100:1000;
R=100:100:500;
figure(3)
%h3=mesh(Density,R,Accuracy);
h3=surf(Density,R,Accuracy);
%set(h2,'facealpha',0.3);
%plot(100:100:1500,Accuracy(1,1:15),'yellow');
hold on;

for i=1:5
         InitialAnchorRatio=0.5;
             BeaconRange=i;
    for j=1:10
     SUNumber=100*j;
     filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
     tmp=load(filename);
     Warn=tmp.Warn;
     Accuracy(i,j)=sum(Warn)/100;
    end
end

Density=100:100:1000;
R=100:100:500;
figure(4)
h4=surf(Density,R,Accuracy);
% for i=1:15
%  SUNumber=100*i;
%  BeaconRange=5;
%   InitialAnchorRatio=0.05;
%  filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
% tmp=load(filename);
% Warn=tmp.Warn;
% Accuracy(i)=sum(Warn)/100;
% end
% 
% figure(1)
% plot(100:100:1500,Accuracy(1,1:15),'red');
% hold on;

% for i=1:15
%  SUNumber=100*i;
%  BeaconRange=5;
%   InitialAnchorRatio=0.1;
%  filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
% tmp=load(filename);
% Warn=tmp.Warn;
% Accuracy(i)=sum(Warn)/100;
% end
% 
% figure(1)
% plot(100:100:1500,Accuracy(1,1:15),'black');
% hold on;
% 
% for i=1:15
%  SUNumber=100*i;
%  BeaconRange=5;
%   InitialAnchorRatio=0.5;
%  filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
% tmp=load(filename);
% Warn=tmp.Warn;
% Accuracy(i)=sum(Warn)/100;
% end
% 
% figure(1)
% plot(100:100:1500,Accuracy(1,1:15),'green');
% hold on;