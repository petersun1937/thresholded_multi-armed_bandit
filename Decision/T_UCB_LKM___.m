function [k, F_hat] = T_UCB_LKM___(N, a, c_t, c, y, delta, t, N_c, N_tild)
    F_pi = ones(size(N));  %F_1_ = zeros(1,3); 
    Q_ = zeros(size(N));
    %F_pi = 1;
    
    %[yu,iy,~] = unique(y);      % yy returns unique entries, iy returns their original indices
    %au = a(iy);  deltau = delta(iy);
    
    % Check for the y_t that are greater than c_t, return indices
    %ygc = find(y > c_t); 
    
    %[yy,tt] = sort(yu);
    [yy,tt] = sort(y);      % Sort y_t in ascending order
    delta_ = delta(tt);     % Reorder delta according to the sorting
    S=cell(1,length(N));  Q_a=cell(1,length(N));
    Var_temp=cell(1,length(N));
    
    for ai=1:length(N)
        isa(ai,:) = (a==ai);        % Indicators of whether arm ai is pulled in y_t
        %uncen_cond(ai,:) = (delta).*isa(ai,:);  % if X is observed
        %cen_cond(ai,:) = (~delta).*isa(ai,:);
        
        isa_(ai,:)=isa(ai,tt);      % Reorder the indicators
        %uncen_cond_(ai,:) = (delta_).*isa_(ai,:);  % if X is observed
        cen_cond_(ai,:) = (~delta_).*isa_(ai,:);    % censored vector for arm ai
        
       % yy.*isa_(ai,:);
       %Q(ai) = (yy(1:t) > ygc_).*isa(ai,:);
       %tta(ai,:) = (yy.*isa_(ai,:) ~= 0);  
       
       yya = yy(isa_(ai,:));      % All observations from arm ai
       ygc_a = find(yya > c_t);  % indices of y_t being greater than c_t for arm ai
       
       if (~isempty(ygc_a))
           %yya_gc = yya(ygc_a); 
           %Q_a{ai} = length(yya)-(1:length(yya));
           Q_a{ai} = N(ai)-ygc_a;
           cen_a = cen_cond_(ai,isa_(ai,:));    % Discard indices where arm ai's not pulled
           %if (~isempty(yya))
       
            freq = ones(size(ygc_a),"like",ygc_a);
            %freq = ones(size(yy),"like",yy);
            obscumfreq = cumsum(freq .*~cen_a(ygc_a));
            D = [obscumfreq(1) diff(obscumfreq)];           % Same as ~cen_a(ygc_a)?
            N_ = N(ai)-Q_a{ai};
            S{ai}(1,:) = cumprod(1 - D./N_);  
            
            %Var_temp{ai}(1,:) = cumprod(D./((N_).*(N_-D)));
            %Var_temp{ai}(1,:) = cumsum(D./((N_).*(N_-D)));
            %Var_temp{ai}(1,:) = cumsum((1-S{ai})./((N_-D).*S{ai}));
            Surv_prob = S{ai}(length(S{ai}));
            %if (Surv_prob==0) Surv_prob=eps(0); end
            %Var_temp{ai}(1,:) = cumsum((Surv_prob)./((N_).*(1-Surv_prob)));     % Somehow works?
            %Var_temp(ai) =  Var_temp(ai)+(Surv_func)./ ((N_(length(N_))).*(1-Surv_func)) ;
            
            %S{ai}(2,:) = yya;  
       end
       %{
       if (~isempty(Var_temp{ai}) & ~isnan(Var_temp{ai}))
            Var_(ai) = Var_temp{ai}(length(Var_temp{ai}));
            %Var_temp_(ai) = sum(Var_temp{ai}(1,:));
       elseif(isempty(Var_temp{ai}))
           Var_(ai)=1;
       else
           Var_(ai)=0;
       end
           %}
           
       if (~isempty(S{ai}))
            F_pi(ai) = S{ai}(length(S{ai}));
       else
           F_pi(ai) = 1;
       end
       
       %N_gc(ai) = sum((c(1:t)>=c_t)&isa(ai,:));
    end

    
    F_hat = 1-F_pi;

    
    %Var = (1-F_hat)./(F_hat.*(N));
    %Vinf = (Var==Inf); Var(Vinf)=0;
    %Var(Vinf)=max(Var)*10;

    %Std = sqrt(Var);
    %Std(Std==inf)=0.5;
    
    %Std_ = sqrt(Var_);
    %if (N_c(Std_==inf)>30)
    %   Std_(Std_==inf)=1;
    %end
    %Std_(Std_==Inf)=1; %Var_(F_hat==1|Var_==-Inf)=0;
    %stdinf = (Std_==Inf); Std_(stdinf)=0;
    %Std_(stdinf)=max(Std_);
    
    %Var_ = (1-(1-F_hat).^2).*Var_temp_;
    %Var_ = (1-F_hat).^2.*(1-Var_temp_);
    

    
    %ub = F_hat + sqrt((2./N).*log(t));
    %ub = F_hat + sqrt((2./(N-Q_)).*log(t));
    %ub = F_hat + sqrt(((2)./(N_c)).*log(t));
    %ub = F_hat + sqrt(((2)./(N_gc)).*log(t));
    %ub = F_hat + sqrt(((0.5)./(N_tild)).*log(4*t^2));
    
    ub_ = F_hat + sqrt((2./N_tild).*log(t));
    %ub = F_hat + sqrt(((2.*Std_)./(N)).*log(t));
    ub = F_hat + sqrt(((2)./(sqrt(N.*N_tild))).*log(t));
    %ub__ = F_hat + sqrt((2.*Var)./(N).*log(t));
    %ub = F_hat + sqrt((2.*Std)./(N_tild).*log(t));
    m = max(ub);
    
    ub(isnan(ub))=inf;
    if ( ~isnan(m))
        mI = find(ub == m);
        k = mI(randi(length(mI)));
    else
        k = randi(length(F_hat));
    end
  

end