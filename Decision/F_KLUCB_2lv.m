function [k,b_k] = F_KLUCB_2lv(p1,p2,s,n)

    f = log(1 + n*log(log(n)))./s;
    %f = (log(t) + c*log(log(t+1)))./s;
    
    b_k = KLBinSearch_2lv(f,p1,p2);
    
    b_k(p1.*p2==1) = 1; 
    b_k(s==0) = 1; 
    
    %ArmToPlay = PickingMaxIndexArm(ucb);
    m = max(b_k);
    if ( ~isnan(m))
        mI = find(b_k == m);
        k = mI(randi(length(mI)));         % Randomly pick one of the max
    else
        k = randi(K);
    end

end