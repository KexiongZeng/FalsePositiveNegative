function [RowAnchor,ColumnAnchor,NumAnchorsAvailable] = CheckForAvailableAnchors(Row,Column,Range)
pa = parameter;
SUNumber=pa.SUNumber;
SizeOfGrid = pa.SizeOfGrid;
BeaconProbability=pa.BeaconProbability;
global AnchorNodes;
global SuspiciousFlag;
global BeaconControl;
RowAnchor = zeros(1,SUNumber);
ColumnAnchor = zeros(1,SUNumber);

row_lower = Row - Range;
row_upper = Row + Range;
col_lower = Column - Range;
col_upper = Column + Range;

if(row_lower < 1)
    row_lower = 1;
end

if(row_upper > SizeOfGrid)
    row_upper = SizeOfGrid;
end

if(col_lower < 1)
    col_lower = 1;
end

if(col_upper > SizeOfGrid)
    col_upper = SizeOfGrid;
end

[mAnchorList,nAnchorList]= size(AnchorNodes);
NumAnchorsAvailable = 0;
k=1;
for i = 1: nAnchorList
    
    AnchorX = AnchorNodes{1,i}(1);
    AnchorY=AnchorNodes{1,i}(2);
    AnchorInd=AnchorNodes{1,i}(3);
    if(BeaconControl(1,i))
        if(AnchorX>=row_lower && AnchorX <= row_upper && AnchorY>=col_lower && AnchorY<= col_upper&&SuspiciousFlag(1,AnchorInd)~=1)%Set BeaconProbability uniformly distributed probability for beacon signal
            RowAnchor(k) = AnchorX;
            ColumnAnchor(k) = AnchorY;
            NumAnchorsAvailable = NumAnchorsAvailable + 1;
            k=k+1;
        end
    end
end
if(NumAnchorsAvailable >0)     
    RowAnchor = RowAnchor(1:NumAnchorsAvailable);
    ColumnAnchor = ColumnAnchor(1:NumAnchorsAvailable);
end
    
end