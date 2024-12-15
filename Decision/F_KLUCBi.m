function [k,q] = F_KLUCBi(mu,s,t)

    [~, s2] = size(mu);
    
    for i=1:s2
        %nu(i) = sum(mu(:,i).*s(:,i),'all')/sum(s(:,i),'all');
        [mus,js] = max(mu(:,i));
        nu(i) = mus;
        
        f(i) = log(1 + t*(log(t))^2)./sum(s(:,i),'all');
    end

    q = KLBinSearch(f,nu);
    
    
    %b_k = NaN(size(p));
    %b_k(~isnan(p)) = KLBinSearch(f(~isnan(p)),p(~isnan(p)));
    
    
    
    %q(p==1) = 1; 
    % Force select any arm that's not explored yet
    q(s==0) = 1; 

    m = max(q);
    % Randomly pick one of the max
    mI = find(q == m);
    k = mI(randi(length(mI)));

end