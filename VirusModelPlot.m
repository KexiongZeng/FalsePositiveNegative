%Plot virus propagation model
function VirusModelPlot(A,time)
pa=parameter;
SUNumber=pa.SUNumber;
BeaconProbability=pa.BeaconProbability;
p_0=0.01*2*rand(SUNumber,1);
% s=eye(SUNumber)+A;
% eta_t=zeros(1,time);
% for i=1:time
%    p_t=(s^i)*p_0; 
%    eta_t(1,i)=sum(p_t);
% end
p_tmp=p_0;
p_t=zeros(SUNumber,1);
eta_t=zeros(1,time);
eta_t(1,1)=sum(p_0);
for i=2:time
   for j=1:SUNumber
       Neighbor=find(A(j,:));
       [m,n]=size(Neighbor);
       product=1;
       for k=1:n
          product=product*(1-BeaconProbability*p_tmp(Neighbor(1,k),1)); 
       end
      % p_t(j,1)=1-(1-p_tmp(j,1))*product;
      %p_t(j,1)=1-product+p_tmp(j,1);
      p_t(j,1)=1-(1-p_tmp(j,1))*product;
       if(p_t(j,1)>1)
          p_t(j,1)=1; 
       end
   end
   eta_t(1,i)=sum(p_t);
   p_tmp=p_t;
end
figure(1)
plot(eta_t,'r');
hold on;
grid on;