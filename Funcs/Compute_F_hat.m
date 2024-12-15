function [F_hat_t,F_phi_t,F_t] = Compute_F_hat(c,t,X,N,N_hat,Nt,F_hat,f,F_phi,F,nu_c)
    K = length(N); FL = zeros(1,K); FU = zeros(1,K); F_phi_t = zeros(1,K);
    
    F_t = sum((X(:,1:t) >= c(t+1)), 2)'./N;
    %F_tt = F_t.*N./N_tild;
    
    cc = (c(1:t) > c(t+1));  % (x < c_s)
    c_t = c(t+1);
    
    %FL = sum((X(:,1:t) >= c(t+1)) & (~cc), 2)'./(N_hat);
    %FU = sum((X(:,1:t) >= c(1:t)) & (cc), 2)'./(N);
    %F_t = FL+FU;
    
    ff = sum(f,2);
    phi = cc.*f;
    %phi = f;
    %F_phi_t = sum(phi,2)'./N;
    %for s=1:t-1
    %    F_phi_(:,s) = sum(phi(:,1:s),2)./Nt(:,s);
    %end
    F_hat_t = F_t;

    if t>2 
        %F_hat_ct = Compute_F_hat(c,t-1,X(:,1:t-1),N,F_hat(:,1:t-1),phi(:,1:t-1));
            % F; F+(1./N(a)).*sum(F_hat_ct(a,t-2)-F_hat(a,1:t-2))./(1-F_hat(a,1:t-2)) ,2)
        F_hat_ct = F_t;
        
        F_hat(F_hat>=1)=0.99; %F_phi(F_phi>=1)=0.99; F_phi(F_phi==0)=0.01; F_phi_t(F_phi_t==0)=0.01;
        F(F==1)=0.99;
        for a=1:K
            N_p(a) = sum(phi(a,1:t-1) ,2);
            F_est(a) = sum( ((F_hat_ct(a)-F_hat(a,1:t-1))./(1-F_hat(a,1:t-1))).*phi(a,1:t-1) ,2);
            F_hat_t(a) = F_t(a)+F_est(a)./(N(a));
            
            %F_est(a) = sum( ((F_hat_ct(a)-F(a,1:t-1))./(1-F_hat(a,1:t-1)))*sum(phi(a,1:t-1),2) ,2);
            %F_hat_t(a) = FL(a)+F_est(a)./(N_hat(a));
            
            %F_est(a) = sum( ((F_hat_ct(a)-F(a,1:t-1))./(1-F_hat(a,1:t-1))),2)*sum(phi(a,1:t-1),2)/(t-1);
            %F_hat_t(a) = F_t(a)+F_est(a)./(N(a));
            
           
            if(isnan(F_hat_t(a))||F_hat_t(a)==Inf)
                F_hat_t(a)=F(a);
            end
            if F_hat_t(a)<0
                F_hat_t(a)=0;
            end
        end
    end
end