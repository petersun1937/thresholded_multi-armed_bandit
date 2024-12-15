function [as] = LKMUCB(j_idx, m, epoch, N, a, j, y, delta, t, T)
    F_pi = ones(size(N));

    [yy,tt] = sort(y);      % Sort y_t in ascending order
    delta_ = delta(tt);     % Reorder delta according to the sorting
    S=cell(1,length(N));  Q_a=cell(1,length(N));
    
    for ai=1:length(N)
        isa(ai,:) = (a==ai);        % Indicators of whether arm ai is pulled in y_t
        isa_(ai,:)=isa(ai,tt);      % Reorder the indicators
        cen_cond_(ai,:) = (~delta_).*isa_(ai,:);    % censored vector for arm ai
        
       
       yya = yy(isa_(ai,:));      % All observations from arm ai
       ygc_a = find(yya > j);  % indices of y_t being greater than c_t for arm ai
       
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
    
    
    [F_max, max_i] = max(F_hat);
    %F_hat_p = F_hat;  F_hat_p(max_i)=[];
    
    
    F_hat_diff = F_max-F_hat;
    F_hat_diff(max_i)=[];
    %[max_F_diff, max_i] = max(F_hat_diff);
    eps = sqrt(16*log(T*epoch)/((m+1)*epoch));
    
    if (j_idx <= m) && prod(F_hat_diff>=eps)
        if ( ~isnan(F_max))
            mI = find(F_hat == F_max);
            as = mI(randi(length(mI)));
            %L{j_idx} = mI(randi(length(mI)));
            
            %as = mI;
        else
            as = 0;
            %L{j_idx} = randi(length(F_hat));
        end 
    else
        
        % Best arm undetermined
        as = 0;
    end
end