function [k] = T_UCB_LKM__(N, a, c_t, c, y, delta, t, N_c, N_tild)
    F_pi = ones(size(N));  %F_1_ = zeros(1,3); 
    
    Q_ = zeros(size(N));
    %F_pi = 1;
    
    
    %yy = unique(y);
    [yy,iy,~] = unique(y);      % yy returns unique entries, iy returns their original indices
    
    % Check for the y_t that are greater than c_t, return indices
    ygc = find(yy > c_t); 
    
    %yy = repmat(y,length(ygc),1);
    %yt = y(ygc);
    %ycond = yy > yt';   ycond_ = yy >= yt';
    f=cell(1,length(N));  %x=cell(1,length(N));
    
    for ai=1:length(N)
        isa(ai,:) = (a==ai);
        %uncen_cond(ai,:) = (delta(1:t)).*isa(ai,:);  % if X is observed
        
        cen_cond(ai,:) = (~delta(1:t)).*isa(ai,:);  % 
        [f{ai}(:,1),f{ai}(:,2)]= ecdf(y.*isa(ai,:),'censoring',cen_cond(ai,:),'function','survivor');
        
        
        %Q_(ai) = sum((y(1:t) == c_t).*isa(ai,:));
        
        %N_gc(ai) = sum((c(1:t)>=c_t)&isa(ai,:));
    end
    
    
    
    
    for s=1:length(ygc)

        a_s=a(iy(ygc(s)));

        y_s = yy(ygc(s));            % the uncensored obs (X)
        ycond = y(1:t) > y_s;       %ycond_ = y(1:t)>=y(ygc(s));
        %ycond__ = y(1:t) == y_s;    %
        
        F_1 = zeros(size(N));
        F_1(a_s) = 1;
        
        % Loop through the actions (channels) to calculate Q's wrt each
        % action
        for ai=1:length(N)
            %F_1(ai) = sum(ycond__.*uncen_cond(ai,:));
            Q(ai) = sum(ycond.*isa(ai,:));
        end
     
            F_2 = (N-Q);

        % Define 0/0 as 1
            FF = F_1./F_2;
            FF((F_1==0)&(F_2==0))=0;  % zero or one?

            F_pi = F_pi.*(1-FF);

            %end
            %end
            %if (req(length(req))<=c_t)
            %    F_pi = zeros(size(N'));
            %end

        %end
    end
    
    F_hat = 1-F_pi;
    %ub = F_hat + sqrt((2./N).*log(t));
    %ub = F_hat + sqrt((2./(N-Q_)).*log(t));
    ub = F_hat + sqrt(((0.2)./(N_c)).*log(t));
    %ub = F_hat + sqrt(((2)./(N_tild)).*log(t));
    m = max(ub);
    
    if ( ~isnan(m))
        mI = find(ub == m);
        k = mI(randi(length(mI)));
    else
        k = randi(length(F_hat));
    end
end