clear;
close all;
clearvars -global SpoofedSUCount;
global RealCoordinate;
global FalseCoordinate;
global SpoofedSUCount
global SpoofedSUIndex;
global AttackerLocation;
global SpoofedLocation;
for m=1:10%SUNumber
    for q=4%InitialAnchorRatio
        for o=1:5%BeaconRange
pa = parameter;
SUNumber = pa.SUNumber(m);
SpoofRange=pa.SpoofRange;
RunTimes=pa.RunTimes;
InitialAnchorRatio=pa.InitialAnchorRatio(q);
NumInitialAnchors=SUNumber*InitialAnchorRatio;
PresetTime=pa.PresetTime;
BeaconRange=pa.BeaconRange(o);
BeaconProbability=pa.BeaconProbability;
ErrorTolerance=pa.ErrorTolerance;
FalsePositive=zeros(1,RunTimes);
Warn=zeros(1,RunTimes);
SpoofedCountArray=zeros(1,RunTimes);
for r=1:RunTimes
   GenerateCoordinate(SUNumber); 
   A=GetAdjacencyMatrix(RealCoordinate,BeaconRange,SUNumber);
   B=GetAdjacencyMatrix(FalseCoordinate,BeaconRange,SUNumber);
   SpoofedCountArray(r)=SpoofedSUCount;
   StatusFlag=zeros(1,SUNumber);
   %Generate different Initial Anchors
   p=randperm(SUNumber);
   InitialAnchorInd=p(1:NumInitialAnchors);
   StatusFlag(InitialAnchorInd)=1; %Mark as verified
   Lia=ismember(InitialAnchorInd,SpoofedSUIndex);
   if(sum(Lia))
      for i=1:NumInitialAnchors
         if(Lia(i))
            StatusFlag(InitialAnchorInd(i))=2;% Mark as verification failure 
         end
      end
   end

   AnchorNum=zeros(1,PresetTime);%Like eta_t for every time slot
   for t=1:PresetTime
       AvailableAnchorInd=find(StatusFlag(1,:)==1);%Get all anchors in the network
       [m1,n1]=size(AvailableAnchorInd);
       AnchorNum(t)=n1;
       for i=1:n1
           if(rand(1)>=(1-BeaconProbability))%Verify neighbors with probability beta
           NeighborInd=find(A(AvailableAnchorInd(i),:));
           [m2,n2]=size(NeighborInd); 
               for j=1:n2
                   if(StatusFlag(NeighborInd(j))==0)%If it has not been verified before
                         XEst=FalseCoordinate{1,AvailableAnchorInd(i)}(1);
                         YEst=FalseCoordinate{1,AvailableAnchorInd(i)}(2);
                         %[row_lower,row_upper,column_lower,column_upper]=SetBoundary(XEst,YEst,BeaconRange );
                         GPSX=FalseCoordinate{1,NeighborInd(j)}(1);
                         GPSY=FalseCoordinate{1,NeighborInd(j)}(2);
                         %Error_est = sqrt((XEst-GPSX)^2 + (YEst-GPSY)^2);
                         %[row_lower,row_upper,column_lower,column_upper ] = SetBoundary(XEst,YEst,BeaconRange);
                         %if(Error_est<=ErrorTolerance)
                         if(((GPSX-XEst)^2+(GPSY-YEst)^2)<=BeaconRange^2)
                            StatusFlag(NeighborInd(j))=1;%Verification succeeds 
                            display('We got a new anchor!');
                         else
                            StatusFlag(NeighborInd(j))=2;%Verification fails
                            display('We got a suspicious node!');
                         end
                   end
               end
           end
       end
   end
   Unverified=find(StatusFlag(1,:)==0);
   VerificationFail=find(StatusFlag(1,:)==2);
 
   [tmp,UnverifiedNum]=size(Unverified);
   %Observation verification
   for k=1:UnverifiedNum
     NeighborInd=find(B(Unverified(k),:));
     NeighborStatus=StatusFlag(NeighborInd);
     if(find(NeighborStatus(1,:)==1))%Anchor exist
        VerificationFail=[VerificationFail,Unverified(k)]; 
     end
   end
   [tmp,VerificationFailNum]=size(VerificationFail);
   XCor=zeros(1,VerificationFailNum);
   YCor=zeros(1,VerificationFailNum);
   if(VerificationFailNum)
       Warn(r)=1;
    NumatSpoofLoc=0;
    for k=1:VerificationFailNum
        XCor(k)=FalseCoordinate{1,VerificationFail(k)}(1);
        YCor(k)=FalseCoordinate{1,VerificationFail(k)}(2);
    end
    SpoofLoc=[mode(XCor),mode(YCor)]; % Get the most frequent coordinate as spoofing location
   for i=1:SUNumber
       Loctmp=[FalseCoordinate{1,i}(1),FalseCoordinate{1,i}(2)];
       if(Loctmp(1)==SpoofLoc(1)&&Loctmp(2)==SpoofLoc(2))
          NumatSpoofLoc= NumatSpoofLoc+1;
       end
       
   end
   FalsePositive(r)=NumatSpoofLoc-SpoofedSUCount;
   else
       if(~SpoofedSUCount)%If there is no SU spoofed, detection is all right
       Warn(r)=1;
       end
       FalsePositive(r)=0-SpoofedSUCount;
   end
%    figure(1)
%    plot(AnchorNum);
%    ylim([0,3000]);
%    grid on;
%    hold on;
end
    filename=['Result_SUNUmber_',num2str(SUNumber),'_SpoofRange_',num2str(SpoofRange),'_BeaconRange_',num2str(BeaconRange),'_InitialAnchorRatio_',num2str(InitialAnchorRatio),'.mat'];
    save(filename,'FalsePositive','Warn');
        end
    end
end
beep;