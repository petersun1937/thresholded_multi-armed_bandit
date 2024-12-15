function [F_hat_t] = Compute_F_hat_(c,t,X,N,F_hat,phi)
K = length(N);
    %if t>2
        F = sum((X(:,1:t) > c), 2)'./N;
        F_hat_t = F;
        %F_hat_ct = Compute_F_hat(c,t-1,X(:,1:t-1),N,F_hat(:,1:t-1));
            % F; F+(1./N(a)).*sum(F_hat_ct(a,t-2)-F_hat(a,1:t-2))./(1-F_hat(a,1:t-2)) ,2)
        %F_hat(F_hat==1)=0;
        for a=1:K
            %F_hat_t(a) = F(a)+(1./N(a)).* sum( (F_hat_ct(a)-F_hat(a,1:t-1))./(1-F_hat(a,1:t-1)) ,2);
            F_hat_t(a) = (N(a).*F(a)-sum( (F_hat(a,1:t-1)./(1-F_hat(a,1:t-1))).*phi(a,1:t-1) ,2))...
                ./(N(a)- sum( (1./(1-F_hat(a,1:t-1))).*phi(a,1:t-1) ,2));
            if(isnan(F_hat_t(a))||F_hat_t(a)==Inf)
                F_hat_t(a)=F(a);
            end
            
            if(F_hat_t(a)==1 && F(a)~=1)
                F_hat_t(a)=F(a);

            elseif(F_hat_t(a)==1 && F(a)==1)
                F_hat_t(a)=0;
            end
        end
    %else
    %    F_hat_t = zeros(1,K);
    %end
end