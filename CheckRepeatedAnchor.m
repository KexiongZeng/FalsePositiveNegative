function [ RepeatedAnchor ] = CheckRepeatedAnchor( AnchorNum )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
global AnchorIndex;

%[m,n]=size(AnchorNodes);
RepeatedAnchor = 0;
Lia=ismember(AnchorIndex,AnchorNum);
if(sum(Lia))
    RepeatedAnchor=1;
end
% for i=1:m
%     if(AnchorNodes{1,i}(3)==AnchorNum)
%         RepeatedAnchor = 1;
%         break;
%     end
% end

% ind=find(AnchorIndex(1,:)==AnchorNum);
% if(ind)
%     RepeatedAnchor=1;
% end
