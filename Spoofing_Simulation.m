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
        while(find(AnchorIndex(1,:)==ind))
            ind=ind+1;
        end
        InitialAnchor{1,i} = [RealCoordinate{1,ind}(1),RealCoordinate{1,ind}(2),ind];
        AnchorIndex(1,i)=ind;
        %Check if initial anchors are under attack
        Lia=ismember(SpoofedSUIndex,ind);
        if(sum(Lia))
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
      %BeaconControl=ones(1,LastNumChecked);
       AvailableBeaconInd=find(BeaconControl);
       [m1,n1]=size(AvailableBeaconInd);
       for i=1:n1
           IndAnchor=AnchorIndex(1,AvailableBeaconInd(1,i));%This anchor index
           PotentialNewAnchor=find(A(IndAnchor,:));
           [m2,n2]=size(PotentialNewAnchor);
           if(SuspiciousFlag(1,IndAnchor)~=1)
            for j=1:n2
                AlreadyChecked = CheckRepeatedAnchor(PotentialNewAnchor(1,j));
                %If Checked? If suspicious?
                    if(AlreadyChecked~=1&&SuspiciousFlag(1,PotentialNewAnchor(1,j))~=1)
                        %If added?
                        if(ismember(PotentialNewAnchor(1,j),NewAnchorAvailableInd)~=1)
                         RealSUCoordinates = RealCoordinate{1,PotentialNewAnchor(1,j)};
                         FalseSUCoordinates = FalseCoordinate{1,PotentialNewAnchor(1,j)};
                         XEst=RealCoordinate{1,IndAnchor}(1);
                         YEst=RealCoordinate{1,IndAnchor}(2);
                         %[row_lower,row_upper,column_lower,column_upper]=SetBoundary(XEst,YEst,BeaconRange );
                         GPSX=FalseSUCoordinates(1,1);
                         GPSY=FalseSUCoordinates(1,2);
                         Error_est = sqrt((XEst-FalseSUCoordinates(1,1))^2 + (YEst-FalseSUCoordinates(1,2))^2);
                         %if(GPSX>=row_lower&&GPSX<=row_upper&&GPSY>=column_lower&&GPSY<=column_upper)
                         if(Error_est<=ErrorTolerance)
                             NewAnchorAvailableInd=[NewAnchorAvailableInd,PotentialNewAnchor(1,j)];
                             NumChecked = NumChecked + 1;

                             NewAnchorAvailable{1,NewInd}=[GPSX,GPSY,PotentialNewAnchor(1,j)];% Use GPS location for new anchors
                             NewInd=NewInd+1;
                             SuspiciousFlag(1,PotentialNewAnchor(1,j))=2;%mark it as verified
                             display('We got a new anchor!');
                         else
                            SuspiciousFlag(1,PotentialNewAnchor(1,j))=1;%raise a suspicion so this node can never be verified
                            display('We got a suspicious node!');
                         end
                        end
                    end
            end
           end
       end
%        for i=1:SUNumber
%             RealSUCoordinates = RealCoordinate{1,i};
%             FalseSUCoordinates = FalseCoordinate{1,i};
%             AlreadyChecked = CheckRepeatedAnchor(i);
%             % It's already verified or not
%             if(AlreadyChecked~=1&&SuspiciousFlag(1,i)~=1)
%                 [row,column,AnchorsAvailable] = CheckForAvailableAnchors(RealSUCoordinates(1,1),RealSUCoordinates(1,2),BeaconRange);%use real topology 
%                 % Have anchor neighbors
% 
%                 if(AnchorsAvailable>0)
%                     SumX = sum(row);
%                     SumY = sum(column);
% 
%                     XEst = SumX / (AnchorsAvailable);
%                     YEst = SumY / (AnchorsAvailable); 
%                     EstLocation{1,i}=[XEst,YEst];
%                     %FalseSUCoordinates are GPS reported locations
%                     Error_est = sqrt((XEst-FalseSUCoordinates(1,1))^2 + (YEst-FalseSUCoordinates(1,2))^2);
%                     % We have to store all new anchors and add them after one
%                     % loop
%                     if(Error_est<=ErrorTolerance)
%                         NumChecked = NumChecked + 1;
%                         NewAnchorAvailable{1,NewInd}=[FalseSUCoordinates(1,1),FalseSUCoordinates(1,2),i];% Use GPS location for new anchors
%                         %NewAnchorAvailable{1,NewInd}=[XEst,YEst,i];% Use estimated location for new anchors
%                         NewInd=NewInd+1;
%                         SuspiciousFlag(1,i)=0;
%                         display('We got a new anchor!');
%                     else
%                         SuspiciousFlag(1,i)=1;%raise a suspicion so this node can never be verified
%                         display('We got a suspicious node!');
%                     end
%                 else %(AnchorsAvailable==0)
%                         SuspiciousFlag(1,i)=2;%We are not sure because this node can hear no anchors
%                         display('We are not sure about this node!');
%                 end
%                 
%             end
%        end
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
    SuspiciousIndex=[find(SuspiciousFlag(1,:)==0),find(SuspiciousFlag(1,:)==1)];
    Lia=ismember(SuspiciousIndex,SpoofedSUIndex);
    Accuracy=sum(Lia)/SpoofedSUCount;
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

filename=['Spoof_Result_SUNumber_',num2str(SUNumber),'_BeaconRange_',num2str(BeaconRange),'_ErrorTolerance_',num2str(ErrorTolerance)];
    save(filename,'FalsePositive','SpoofedArray','UnverifiedArray','TotalVerifiedNum_Time','Accuracy');