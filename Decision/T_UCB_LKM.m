function [k, F_hat] = T_UCB_LKM(N, a, c_t, y, delta, t, N_tild)
    F_pi = ones(size(N));

    [yy,tt] = sort(y);      % Sort y_t in ascending order
    delta_ = delta(tt);     % Reorder delta according to the sorting
    S=cell(1,length(N));  Q_a=cell(1,length(N));
    
    for ai=1:length(N)
        isa(ai,:) = (a==ai);        % Indicators of whether arm ai is pulled in y_t
        isa_(ai,:)=isa(ai,tt);      % Reorder the indicators
        cen_cond_(ai,:) = (~delta_).*isa_(ai,:);    % censored vector for arm ai
        
       
       yya = yy(isa_(ai,:));      % All observations from arm ai
       ygc_a = find(yya > c_t);  % indices of y_t being greater than c_t for arm ai
       
       if (~isempty(ygc_a))

           Q_a{ai} = N(ai)-ygc_a;
           cen_a = cen_cond_(ai,isa_(ai,:));    % Discard indices where arm ai's not pulled

            freq = ones(size(ygc_a),"like",ygc_a);
            obscumfreq = cumsum(freq .*~cen_a(ygc_a));
            D = [obscumfreq(1) diff(obscumfreq)]; % Death events
            N_ = N(ai)-Q_a{ai};                 
            S{ai}(1,:) = cumprod(1 - D./N_);  % Calculate the survival function
 
       end

      % If no survival functoin calculated, assign 1 as estimate
       if (~isempty(S{ai}))
            F_pi(ai) = S{ai}(length(S{ai}));
       else
           F_pi(ai) = 1;
       end
    end

    % Calculated ccdf
    F_hat = 1-F_pi;

    % Calculate weight for each arm and select the max weight
    ub = F_hat + sqrt(((2)./(sqrt(N.*N_tild))).*log(t));
    m = max(ub);
    
    ub(isnan(ub))=inf;  % Detect NaN case, replace with infinity
    
    % If multiple arms selected, pick one randomly

    mI = find(ub == m);
    k = mI(randi(length(mI)));

  

end