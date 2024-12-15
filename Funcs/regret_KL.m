function [lb,I] = regret_KL(mu)
    mus = ones(size(mu))*max(mu,[],'all');
    K = length(mu);
    newmu=zeros(size(mu)); newmus=zeros(size(mu));
    for k=1:K
        %I = mu(k)*log(mu(k)/mus)+(1-mu(k))*log((1-mu(k))/(mus));
        ep1 = (max(mu,[],'all')-mu(k))/4;
        ep2 = (max(mu,[],'all')-mu(k))/4;
        newmu(k) = mu(k)+ep1;
        newmus(k) = mus(k)-ep2;
        I(k) = KLDiv(newmu(k),newmus(k));
    end
    
    

    temp = 1./I;

    %lb = nansum((mus-mu)./I,'all');
    lb = sum(temp(isfinite(temp)),'all');
end
