function [k, ub, lb] = F_UCB(mu,T,delta)
    
    ub = mu + sqrt((2./T).*log(1/delta));
    lb = mu - sqrt((2./T).*log(1/delta));
    m = max(ub);
    % Randomly pick one of the max-valued arm
    if ( ~isnan(m))
    mI = find(ub == m);
    k = mI(randi(length(mI)));
    else
    k = randi(length(mu));
    end
        
        
end
    
