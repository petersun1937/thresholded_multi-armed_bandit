function [lb,I] = regretLB_Bern(mu)
    mus = ones(size(mu))*max(mu,[],'all');
    K = length(mu);
    %for k=1:K
        %I = mu(k)*log(mu(k)/mus)+(1-mu(k))*log((1-mu(k))/(mus));
        I = KLDiv(mu,mus);
        
        temp = 1./I;
        
        %lb = nansum((mus-mu)./I,'all');
        lb = sum(temp(isfinite(temp)),'all');
        
    %end
end
