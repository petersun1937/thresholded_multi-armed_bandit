function [k, ub, lb] = T_UCB_cap(F,N,t)
    
    ub = F + sqrt((2./N).*log(t));
    ub(ub>1)=1;
    lb = F - sqrt((2./N).*log(t));
    m = max(ub);
    % Randomly pick one of the max-valued arm
    if ( ~isnan(m))
    mI = find(ub == m);
    k = mI(randi(length(mI)));
    else
    k = randi(length(F));
    end
        
        
end
    
