function [k] = T_UCB_LKM(N, a, c_t, y, delta, t, N_c)
    F_pi = ones(size(N));  %F_1_ = zeros(1,3); 
    Q_ = zeros(size(N));
    %F_pi = 1;
    
    % Check for the y_t that are greater than c_t, return indices
    ygc = find(y > c_t); 
    
    %yy = repmat(y,length(ygc),1);
    %yt = y(ygc);
    %ycond = yy > yt';   ycond_ = yy >= yt';
    
     f=cell(1,length(N));  %x=cell(1,length(N));
    
    
    for ai=1:length(N)
        isa(ai,:) = (a==ai);
        uncen_cond(ai,:) = (delta(1:t)).*isa(ai,:);  % if X is observed
        cen_cond(ai,:) = (~delta(1:t)).*isa(ai,:);
        
        %[f{ai}(:,1),f{ai}(:,2)]= ecdf(y.*isa(ai,:),'censoring',cen_cond(ai,:),'function','survivor');
        
        %{
        yisa = y.*isa(ai,:);
        indyz = find(yisa==0);  yisa(indyz)=[];
        cen_cond_a = cen_cond(ai,:); cen_cond_a(indyz) = [];
        delta_a=delta;  delta_a(indyz) = [];

        %[f{ai}(:,1),f{ai}(:,2)]= ecdf_(y.*isa(ai,:),N,isa,delta,'censoring',cen_cond(ai,:),'function','survivor');
        [fff,xxx]= ecdf_(yisa,N(ai),isa',delta_a','censoring',cen_cond_a,'function','survivor');
        if ~isempty(fff)
            f{ai}(:,1)=fff;  f{ai}(:,2)=xxx;
        end
        
        %}
        %Q_(ai) = sum((y(1:t) == c_t).*isa(ai,:));
    end
    
    for s=1:length(ygc)
        %yec = find(y == y(ygc(ss)));
        
    %end
    %if ~isempty(yec)
        %for s=1:length(yec)
        y_s = y(ygc(s));            % the uncensored obs (X)
        ycond = y(1:t) > y_s;       %ycond_ = y(1:t)>=y(ygc(s));
        ycond__ = y(1:t) == y_s;    %

        % Loop through the actions (channels) to calculate Q's wrt each
        % action
        for ai=1:length(N)
            %Q_tild(ai) = sum((ycond).*(uncen_cond(ai,:)));
            %Q_tild_(ai) = sum((ycond_).*(uncen_cond(ai,:)));
            %Q_und(ai) = sum((ycond).*(cen_cond(ai,:)));
            F_1(ai) = sum(ycond__.*uncen_cond(ai,:));
            Q(ai) = sum(ycond.*isa(ai,:));
        end
            %for si=1:length(req)
                %if (req(si)>c_t)
            %if (y(tt)>c_t)

                %F_1 = (Q_tild_(:,si)-Q_tild(:,si));
                %F_2 = (N(:)-Q_tild(:,si)-Q_und(:,si));         

            %F_1 = (Q_tild_-Q_tild);
            F_2 = (N-Q);
            %F_2 = (N-Q_tild-Q_und);

        % Define 0/0 as 0
            FF = F_1./F_2;
            
            %if any((F_1==0)&(F_2==0))||any(FF==1)
               FF((F_1==0)&(F_2==0))=0;
            %end
            
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
    %ub = F_hat;
    m = max(ub);
    
    if ( ~isnan(m))
        mI = find(ub == m);
        k = mI(randi(length(mI)));
    else
        k = randi(length(F_hat));
    end
    
    %warning('off','stats:ecdf:NoDeath')
    %warning('on','stats:ecdf:NoDeath')
    
end