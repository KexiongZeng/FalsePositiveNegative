%GenerateCoordinate
function GenerateCoordinate(SUNumber)
global RealCoordinate;
global FalseCoordinate;
global SpoofedSUCount
global SpoofedSUIndex;
global AttackerLocation;
global SpoofedLocation;
pa=parameter;
%SUNumber=pa.SUNumber;
SizeOfGrid=pa.SizeOfGrid;
SpoofRange=pa.SpoofRange;
RealCoordinate=cell(1,SUNumber);%Store coordinates for SUNumber SUs
AttackerLocation=[rand(1)*SizeOfGrid,rand(1)*SizeOfGrid];%Attacker Location
SpoofedLocation=[rand(1)*SizeOfGrid,rand(1)*SizeOfGrid];%Spoofing Location set by attacker
%[ row_lower,row_upper,column_lower,column_upper ] = SetBoundary(AttackerLocation(1,1),AttackerLocation(1,2),SpoofRange);
SpoofedSUCount=1;
SpoofedSUIndex=zeros(1,SUNumber);%Store the SU index in Coordinate
SpoofedSUOriginalLocation=cell(1,SUNumber);%Store the original location of SUs spoofed
for i=1:SUNumber
    row=rand(1)*SizeOfGrid;
    column=rand(1)*SizeOfGrid;
    RealCoordinate{1,i}=[row,column];
        if(((row-AttackerLocation(1))^2+(column-AttackerLocation(2))^2)<=SpoofRange^2) % Fall in transmission range

            SpoofedSUOriginalLocation{1,SpoofedSUCount}=[row,column];
            SpoofedSUIndex(1,SpoofedSUCount)=i;
            SpoofedSUCount=SpoofedSUCount+1;

        end
end

 FalseCoordinate=RealCoordinate;
 SpoofedSUCount=SpoofedSUCount-1;
 SpoofedSUIndex=SpoofedSUIndex(1,1:SpoofedSUCount);
 for j=1:SpoofedSUCount
        FalseCoordinate{1,SpoofedSUIndex(1,j)}=SpoofedLocation;      
 end
 
%     save('RealCoordinate.mat','Coordinate');
%     save('FalseCoordinate.mat','FalseCoordinate');
%     save('SpoofInfo.mat','SpoofedSUCount','SpoofedSUIndex');