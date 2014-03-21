% parameter.m
function pa=parameter
%pa.dtn='tvdata_24649.txt';
pa.PowerThresh = -114 ; % Power level in dBm to indicate if a channel is available
pa.NumOfPoints = 25600; % Num of Points used from L-R model
pa.SizeOfGrid = sqrt(pa.NumOfPoints);%Square size
pa.NumOfTowers = 10; % Total Num of Towers/Channels considered
pa.NumOfSimulatedTowers = 10; % Num of Towers whose Propagation characteristics is considered
% pa.dtbs=importdata(pa.dtn);
% pa.dtbs(:,3)=pa.dtbs(:,3)-129.05; % converts power in dBu to dBm
pa.Resolution=8;%0.5mile=800m resolution
%Every gird is 121.1m north-south and 96.3m east-west
%157*157 square
%pa.SUProtectRange=1;%Neighboring Protected Range
%pa.SUNumber=[100,200,300,400,500,600,700,800,900,1000];
pa.SUNumber=[500,1000,1500,2000,2500,3000];
pa.SpoofRange=10;%No spoofing attacker
pa.RunTimes=30;
pa.BeaconRange=[1,2,3,4,5];
pa.ErrorTolerance=8;
pa.InitialAnchorRatio=[0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1];
pa.NumInitialTraitorAnchors=(1:10);
%pa.NumInitialAnchors=round(pa.SUNumber*pa.InitialAnchorRatio);
pa.BeaconProbability=1;
pa.PresetTime=10;