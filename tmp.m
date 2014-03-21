figure(2)    
p_0=0.01*2*rand(SUNumber,1);
    s=eye(SUNumber)+BeaconProbability*A;
    eta_t=zeros(1,101);
    tmp;
    eta_t(1,1)=sum(p_0);
    tmp=p_0;
    for i=2:101
       p_t=s*tmp;
       p_t(find(p_t(:,1)>1))=1;
       tmp=p_t; 
       eta_t(1,i)=sum(p_t);
    end
    plot(eta_t,'r');
    grid on;