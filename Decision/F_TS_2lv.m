function [k,Gamma] = F_TS_2lv(S1,S2,F1,F2)

    %% Recommend arms
    Alpha = [];  Beta=[];
    for n = 1:length(S1)
        % Generate probabilities with Beta distribution
       Alpha = [Alpha betarnd(S1(n)+1,F1(n)+1)]; 
       Beta = [Beta betarnd(S2(n)+1,F2(n)+1)];
    end
    Gamma = Alpha.*Beta;
    %% Apply the arm (selected rate) and observe
    m = max(Gamma);
    % Randomly pick one of the max-valued arm
    if ( ~isnan(m))
        mI = find(Gamma == m);
        k = mI(randi(length(mI)));         
    else
        k = randi(length(Gamma));
    end

end