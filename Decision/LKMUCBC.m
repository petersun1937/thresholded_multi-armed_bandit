function [as] = LKMUCBC(j_idx, m, epoch, F_tild, T)

    [F_max, max_i] = max(F_tild);
    %F_hat_p = F_hat;  F_hat_p(max_i)=[];
    
    
    F_hat_diff = F_max-F_tild;
    F_hat_diff(max_i)=[];
    %[max_F_diff, max_i] = max(F_hat_diff);
    eps = sqrt(16*log(T*epoch)/((m+1)*epoch));
    
    if (j_idx <= m) && prod(F_hat_diff>=eps)
        if ( ~isnan(F_max))
            mI = find(F_tild == F_max);
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