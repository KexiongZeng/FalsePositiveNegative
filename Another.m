clear;
close all;
clearvars -global AnchorNodes
clearvars -global AnchorIndex
clearvars -global SuspiciousFlag
global AnchorNodes;
global AnchorIndex;
global SuspiciousFlag;
global RealCoordinate;
global FalseCoordinate;
global SpoofedSUCount
global SpoofedSUIndex;
global AttackerLocation;
global SpoofedLocation;
global BeaconControl;
pa = parameter;
SUNumber = pa.SUNumber;
RunTimes=pa.RunTimes;
UnverifiedArray=zeros(1,RunTimes);
SpoofedArray=zeros(1,RunTimes);
TimeConsumption=zeros(1,RunTimes);
PresetTime=pa.PresetTime;
BeaconProbability=pa.BeaconProbability;
BeaconRange = pa.BeaconRange;
ErrorTolerance = pa.ErrorTolerance;
NumInitialAnchors = pa.NumInitialAnchors;
for r=1:RunTimes
    GenerateCoordinate;
%     tmp = load('RealCoordinate.mat');
%     RealCoordinate = tmp.Coordinate;
%     tmp=load('FalseCoordinate.mat');
%     FalseCoordinate=tmp.FalseCoordinate;
%     tmp=load('SpoofInfo.mat');
%     SpoofedSUCount=tmp.SpoofedSUCount;   
%     SpoofedSUIndex=tmp.SpoofedSUIndex;
    SpoofedArray(1,r)=SpoofedSUCount;
    EstLocation=cell(1,SUNumber);%Estimated Location
    A=GetAdjacencyMatrix(RealCoordinate,BeaconRange);%output r tells you which nodes of p belong to the same connected component
%
    InitialAnchor=cell(1,NumInitialAnchors);
    AnchorIndex=zeros(1,NumInitialAnchors);%index of current anchors 
    SuspiciousFlag=zeros(1,SUNumber);%initial anchors may be suspicious nodes
    for i=1:NumInitialAnchors
        ind = unidrnd(SUNumber);
       
        % prevent repeated initial anchors
        while(find(AnchorIndex(1,:)==ind))%All initial anchors are not repeated and good
            ind=ind+1;
        end
        InitialAnchor{1,i} = [RealCoordinate{1,ind}(1),RealCoordinate{1,ind}(2),ind];
        AnchorIndex(1,i)=ind;
        %Check if initial anchors are under attack
        Lia=ismember(ind,SpoofedSUIndex);
        if(Lia)
           SuspiciousFlag(1,ind)=1; %raise a suspicion so this node can never be verified
        end
    end
    %BadInitialNum=sum(SuspiciousFlag);%number of bad initial anchors
    AnchorNodes=InitialAnchor;%Keep track on all anchors
    NumChecked = NumInitialAnchors;
    LastNumChecked=0;
    time = 0;
    TotalVerifiedNum_Time=zeros(1,PresetTime); 
    %Veification Process
    while(time<PresetTime)%If no more nodes can be verified
       NewAnchorAvailable = cell(1,1);
       NewAnchorAvailable{1,1} = [0,0,0];
       NewAnchorAvailableInd=0;
       LastNumChecked=NumChecked;
       NewInd=1;
       %One time verification
       BeaconControl=(rand(1,LastNumChecked)>=(1-BeaconProbability));
       AvailableBeaconInd=find(BeaconControl);
       [m1,n1]=size(AvailableBeaconInd);
       for i=1:n1
           NewAnchorInd=find(A(AvailableBeaconInd(1,i),:));
           [m2,n2]=size(NewAnchorInd);
            for j=1:n2
                AlreadyChecked = CheckRepeatedAnchor(NewAnchorInd(1,j));
                    if(AlreadyChecked~=1&&SuspiciousFlag(1,NewAnchorInd(1,j))~=1)
                        if(ismember(NewAnchorInd(1,j),NewAnchorAvailableInd)~=1)
                         AnchorX=RealCoordinate{1,AvailableBeaconInd(1,i)}(1);
                         AnchorY=RealCoordinate{1,AvailableBeaconInd(1,i)}(2);
                         GPSX=FalseCoordinate{1,NewAnchorInd(1,j)}(1);
                         GPSY=FalseCoordinate{1,NewAnchorInd(1,j)}(2);
                         Error=sqrt((AnchorX-GPSX)^2+(AnchorY-GPSY)^2);
                         if(Error<=ErrorTolerance)
                         NewAnchorAvailableInd=[NewAnchorAvailableInd,NewAnchorInd(1,j)];
                         NumChecked = NumChecked + 1;
                         RealSUCoordinates = FalseCoordinate{1,NewAnchorInd(1,j)};
                         NewAnchorAvailable{1,NewInd}=[RealSUCoordinates(1,1),RealSUCoordinates(1,2),NewAnchorInd(1,j)];% Use GPS location for new anchors
                         NewInd=NewInd+1;
                         SuspiciousFlag(1,NewAnchorInd(1,j))=2;%Verified
                         display('We got a new anchor!');
                         else
                         SuspiciousFlag(1,NewAnchorInd(1,j))=1;%Verification Failure
                         display('We got a suspicious node!');
                         end
                        end
                    end
            end
       end
       %Add new anchors to anchor list
      
        [mNewAnchor,nNewAnchor]=size(NewAnchorAvailable);
        [mAnchor,nAnchor] = size(AnchorNodes);
        Value_Beginning = NewAnchorAvailable{1,1}(3);
        if(Value_Beginning ~= 0)
            for k = 1: nNewAnchor
                AnchorNodes{1,nAnchor+k} = NewAnchorAvailable{1,k};        
                AnchorIndex(1,nAnchor+k)= NewAnchorAvailable{1,k}(3); 
            end
        end
        time = time + 1;
        TotalVerifiedNum_Time(1,time)=NumChecked;
     end
    SuspiciousIndex=[find(SuspiciousFlag(1,:)==1),find(SuspiciousFlag(1,:)==2)];
    [m,n]=size(SuspiciousIndex);
    UnverifiedArray(1,r)=n;%All suspicious nodes including spoofing and cannot localization
    FalsePositive=UnverifiedArray-SpoofedArray; % plus means normal node is mistakenly considered as spoofed nodeswhile minus means spoofed nodes are not detected .
    TimeConsumption(1,r)=time;
    
    TotalVerifiedNum_Time=[NumInitialAnchors,TotalVerifiedNum_Time(1,1:end-1)];
    figure(1)
    plot(TotalVerifiedNum_Time);
    hold on;
    %VirusModelPlot(A,time);
    
end

filename=['NoSpoof_Result_SUNumber_',num2str(SUNumber),'_BeaconRange_',num2str(BeaconRange),'_ErrorTolerance_',num2str(ErrorTolerance)];
    save(filename,'FalsePositive','SpoofedArray','UnverifiedArray');