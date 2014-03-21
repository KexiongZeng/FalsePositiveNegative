clear;
close all;
global RealCoordinate;
global FalseCoordinate;
global SpoofedSUCount
global SpoofedSUIndex;
global AttackerLocation;
global SpoofedLocation;
pa = parameter;
SUNumber = pa.SUNumber;
RunTimes=pa.RunTimes;
NumInitialAnchors=pa.NumInitialAnchors;
PresetTime=pa.PresetTime;
BeaconRange=pa.BeaconRange;
BeaconProbability=pa.BeaconProbability;
for r=1:RunTimes
   GenerateCoordinate; 
    A=GetAdjacencyMatrix(RealCoordinate,BeaconRange);
   StatusFlag=zeros(1,SUNumber);
   %Generate different Initial Anchors
   p=randperm(SUNumber);
   InitialAnchorInd=p(1:NumInitialAnchors);
   StatusFlag(InitialAnchorInd)=1; %Mark as verified
   AnchorNum=zeros(1,PresetTime);%Like eta_t for every time slot
   for t=1:PresetTime
       AvailableAnchorInd=find(StatusFlag(1,:)==1);%Get all anchors in the network
       [m1,n1]=size(AvailableAnchorInd);
       AnchorNum(t)=n1;
       for i=1:n1
           if(rand(1)>=(1-BeaconProbability))%Verify neighbors with probability beta
           NeighborInd=find(A(AvailableAnchorInd(i),:));
           [m2,n2]=size(NeighborInd);         
           StatusFlag(NeighborInd)=1;%Mark as verified          
           end
       end
   end
   figure(1)
   plot(AnchorNum);
   ylim([0,3000]);
   xlim([0,20]);
   grid on;
   hold on;
   %Plot mathmatical model
p_0=0.01*2*rand(SUNumber,1);
p_tmp=p_0;
p_t=zeros(SUNumber,1);
eta_t=zeros(1,PresetTime);
eta_t(1,1)=sum(p_0);
for i=2:PresetTime
   for j=1:SUNumber
       Neighbor=find(A(j,:));
       [m,n]=size(Neighbor);
       product=1;
       for k=1:n
          product=product*(1-BeaconProbability*p_tmp(Neighbor(1,k),1)); 
       end
      p_t(j,1)=1-(1-p_tmp(j,1))*product;
      %p_t(j,1)=1-product+p_tmp(j,1);
   
       if(p_t(j,1)>1)
          p_t(j,1)=1; 
       end
   end
   eta_t(1,i)=sum(p_t);
   p_tmp=p_t;
end
figure(1)
plot(eta_t,'r');
end