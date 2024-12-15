function [k] = T_UCB_LKM_(N, a, c_t, y, delta, t)
    F_pi = ones(size(N'));
    
    %F_pi = 1;
    
    % Check for the y_t that are greater than c_t, return indices
    ygc = find(y > c_t);
    
    %yy = repmat(y,length(ygc),1);
    %yt = y(ygc);
    %ycond = yy > yt';   ycond_ = yy >= yt';
    
    for ai=1:length(N)
        isa(ai,:) = (a==ai);
        uncen_cond(ai,:) = (delta(1:t)).*isa(ai,:);
        cen_cond(ai,:) = (~delta(1:t)).*isa(ai,:);
    end
    
    
    
    for s=1:length(ygc)
        ycond = y(1:t)>y(ygc(s)); ycond_ = y(1:t)>=y(ygc(s));
        %ycond__ = y(1:t)==y(ygc(s));
        %yy_cond = repmat(ycond,length(N),1);
        %yy_cond_ = repmat(ycond_,length(N),1);
        %Q_tild = sum((yy_cond).*(uncen_cond),2);
        %Q_tild_ = sum((yy_cond_).*(uncen_cond),2);
        %Q_und = sum((yy_cond).*(cen_cond),2);
        
        
        % Loop through the actions (channels) to calculate Q's wrt each
        % action
        for ai=1:length(N)
            Q_tild(ai) = sum((ycond).*(uncen_cond(ai,:)));
            Q_tild_(ai) = sum((ycond_).*(uncen_cond(ai,:)));
            Q_und(ai) = sum((ycond).*(cen_cond(ai,:)));
        end
            %for si=1:length(req)
                %if (req(si)>c_t)
            %if (y(tt)>c_t)
            
                %F_1 = (Q_tild_(:,si)-Q_tild(:,si));
                %F_2 = (N(:)-Q_tild(:,si)-Q_und(:,si));         
            
            F_1 = (Q_tild_-Q_tild)';
            F_2 = (N-Q_tild-Q_und)';
            
        % Define 0/0 as 1
            FF = F_1./F_2;
            FF((F_1==0)&(F_2==0))=1;

            F_pi = F_pi.*(1-FF);
            
            %end
            %end
            %if (req(length(req))<=c_t)
            %    F_pi = zeros(size(N'));
            %end
            
    end
    
    F_hat = 1-F_pi';
    ub = F_hat + sqrt((2./N).*log(t));
    m = max(ub);
    
    if ( ~isnan(m))
        mI = find(ub == m);
        k = mI(randi(length(mI)));
    else
        k = randi(length(F_hat));
    end
end