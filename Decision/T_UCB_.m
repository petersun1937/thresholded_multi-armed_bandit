function [k, ub, lb] = T_UCB_(F,N,t,N_c,a,c)
    c_t = c(length(c));
    for ai=1:length(N)
        isa(ai,:) = (a==ai);    
        %N_gc(ai) = sum((c(1:t)>=c(t))&isa(ai,:));
    end

    ub = F + sqrt((2./N).*log(t));
    ub(isnan(ub))=inf;
    %ub = F + sqrt(((0.5)./(N)).*log(4*t^2));
    %ub = F + sqrt(((0.1*c_t)./(N)).*log(4*t^2));
    %ub = F + sqrt(((2)./(N_c)).*log(t));
    %ub = F + sqrt(((2)./(N_gc)).*log(t));
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
    
