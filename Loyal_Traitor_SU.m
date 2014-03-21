clear;
close all;
clearvars -global SpoofedSUCount;
global RealCoordinate;
global FalseCoordinate;
global SpoofedSUCount
global SpoofedSUIndex;
global AttackerLocation;
global SpoofedLocation;
M=10;
SU=6;
for m=1:M;%SUNumber
     q=3;%InitialAnchorRatio
         o=5;%BeaconRange
  fprintf('We are running traitors= %d\n',m);
    for su=1:6
        pa = parameter;
SUNumber =pa.SUNumber(su);
RunTimes=pa.RunTimes;
InitialAnchorRatio=pa.InitialAnchorRatio(q);
%InitialTraitorAnchorRatio=pa.InitialTraitorAnchorRatio(m);
NumInitialLoyalAnchors=SUNumber*InitialAnchorRatio;
NumInitialTraitorAnchors=pa.NumInitialTraitorAnchors(m);
%NumInitialTraitorAnchors=1;
PresetTime=pa.PresetTime;
BeaconRange=pa.BeaconRange(o);
BeaconProbability=pa.BeaconProbability;
ErrorTolerance=pa.ErrorTolerance;
FalsePositive=zeros(1,RunTimes);
 FalsePositiveRate=zeros(SU,M);
for r=1:RunTimes
      fprintf('We are running case %d\n',r);
   GenerateCoordinate(SUNumber); 
   A=GetAdjacencyMatrix(RealCoordinate,BeaconRange,SUNumber);
   StatusFlag=zeros(1,SUNumber);
   %Generate different Initial Anchors
   p=randperm(SUNumber);
   InitialAnchorInd=p(1:NumInitialLoyalAnchors+NumInitialTraitorAnchors);
   StatusFlag(InitialAnchorInd(1:NumInitialLoyalAnchors))=1; %Mark as loyal anchors
   StatusFlag(InitialAnchorInd(NumInitialLoyalAnchors+1:NumInitialLoyalAnchors+NumInitialTraitorAnchors))=-1; %Mark as loyal anchors
   AnchorNum=zeros(1,PresetTime);
   for t=1:PresetTime
       MessageBuffer=zeros(1,SUNumber);
       AvailableAnchorInd=[find(StatusFlag(1,:)==1),find(StatusFlag(1,:)==-1)];%Get all anchors in the network
       [m1,n1]=size(AvailableAnchorInd);
       AnchorNum(t)=n1;
       for i=1:n1
           NeighborInd=find(A(AvailableAnchorInd(i),:));
           [m2,n2]=size(NeighborInd); 
               for j=1:n2
                   if(~ismember(NeighborInd(j),InitialAnchorInd))%If it is not initial anchor
                            StatusFlag(NeighborInd(j))=3;%Uncertain
                            MessageBuffer(NeighborInd(j))=MessageBuffer(NeighborInd(j))+StatusFlag(AvailableAnchorInd(i));

                   end
               end
       end
       UncertainInd=find(StatusFlag(1,:)==3);
       [m3,n3]=size(UncertainInd);
       for k=1:n3
          if(MessageBuffer(UncertainInd(k))>=0)
              StatusFlag(UncertainInd(k))=1;%Verification succeeds 
              display('We got a new anchor!');
          else
               StatusFlag(UncertainInd(k))=2;%Verification fails
                display('We got a suspicious node!');
          end
       end
   end
   Unverified=find(StatusFlag(1,:)==0);
   VerificationFail=find(StatusFlag(1,:)==2);
   %Check if any SU is fooled by traitors
   if(~isempty(VerificationFail))
       FalsePositive(r)=1;
   end

end
    FalsePositiveRate(su,m)=sum(FalsePositive)/RunTimes;
    end


%         end
%     end
end
     save('tmp','FalsePositive',' FalsePositiveRate');
beep;