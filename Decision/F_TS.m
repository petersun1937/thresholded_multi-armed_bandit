function [k,Gamma] = F_TS(S,F)

    %% Recommend arms
    Gamma = [];
    for n = 1:length(S)
        % Generate probabilities with Beta distribution
        Gamma = [Gamma betarnd(S(n)+1,F(n)+1)];
    end

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