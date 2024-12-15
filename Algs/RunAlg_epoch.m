function [reward, regret, T_path, a, explod] = RunAlg_epoch(chanrange, Time, alg, req, Rayl, contreq, usew, wsize)
    explod = false;
    if Rayl
        K=3;
        disp("Using Rayleigh channels")
    else
        K = size(chanrange,1);
    end
    
    N = zeros(1,K);  S = zeros(1,K); f = zeros(K,Time); Nt = zeros(K,Time); Nt(:,1)=1;
    m = size(req,2);
    X = zeros(K,Time); X_tild = zeros(K,Time); X_obs = zeros(K,Time);
    count = zeros(1,m);
    %Q_tild = zeros(K,length(req));   Q_und = zeros(K,length(req));
    %Q_tild_ = zeros(K,length(req));
    %S_c = cell(1,length(req)); 
    N_c = cell(1,length(req));
    reward = [];    %SelectedArm = [];
    regret = zeros(1,Time);
    T_path = [];
    timer = [];         % timer
    tend=0;   epoch=1;
    Env = [];
    L_a=zeros(1,m);
    
    F = zeros(1,2);
    F_hat = zeros(K,Time); F_phi = zeros(K,Time); F_ = zeros(K,Time);
    % Compute distribution ground truth of channel coding rates
    nu = (chanrange(:,1)+chanrange(:,2))'./2;
    j_id=m; % or 1
    
    % Compute Rayleigh fading channel ground truth
    if Rayl
        [x_r,xccdf,yccdf] = Rayleigh_x(K,Time,[6 17 14],[19 11 2]);
    end
    
    for k=1:length(req)
        %S_c{k} = zeros(size(N));
        N_c{k} = zeros(size(N))+1;
    end
    
    %c_t=0;
    
    c_ind = 0;
    
    for t = 1:Time
    
    %{
    if c_ind<m
        c_ind = c_ind+1;
    else
        c_ind = 1;
    end  
    %}
        
    % draw c_t from iid uniform
    c_ind = randi(length(req));
    

    
    if ~contreq
        %%
        c(t) = req(c_ind);
        c_t = c(t);
        
    else
        c(t) = unifrnd(1/2, 5/8);
        c_t = c(t);
    end
        % Initialization
        if t < K+1
            a(t) = t;  
        else
            switch alg
                case "T-UCB"
                    N_tild = zeros(1,K); 
                    jtg = c(1:t-1) <= c(t);
                    for k=1:K
                        N_tild(k) = sum((jtg) & a(1:t-1)==k, 2)+1;
                    end
                case "T-UCB-LKM"
                    N_tild = zeros(1,K); 
                    
                    jtg = c(1:t-1) <= c(t);

                    for k=1:K
                        N_tild(k) = sum((jtg) & a(1:t-1)==k, 2)+1;
                    end
                case "T-UCB-C"
                    N_tild = zeros(1,K); 
                    
                    if usew && t>wsize
                        jtg = c(t-wsize:t-1) <= c(t);
                    else
                        jtg = c(1:t-1) <= c(t);
                    end
                    
                    for k=1:K
                        %if usew && t>wsize
                        %    N_tild(k) = sum((ctg) & a(t-wsize:t-1)==k, 2)+1;
                        %else
                        N_tild(k) = sum((jtg) & a(1:t-1)==k, 2)+1;
                        %end
                    end
                    %for s=1:t-1
                        %N_tild(a(s)) = N_tild(a(s))+ (c(s) <= c(t));
                    %end
               case "T-UCB-E"
                    N_tild = zeros(1,K); 
                    %for k=1:K
                     %   N_up(k) = sum((c(1:t-1) > c(t)) & a(1:t-1)==k, 2);
                    %end
                    %N_tild = N - N_up+1;
               case "LKMUCB"
                    N_tild = zeros(1,K); 
                    
                    jtg = c(1:t-1) <= c(t);

                    for k=1:K
                        N_tild(k) = sum((jtg) & a(1:t-1)==k, 2)+1;
                    end
                    %L = cell(1,m);
                    %for mm=1:m
                    %    L{mm}=1:K;
                    %end
               case "LKMUCB-C"
                    N_tild = zeros(1,K); 
                    
                    jtg = c(1:t-1) <= req(j_id);

                    for k=1:K
                        N_tild(k) = sum((jtg) & a(1:t-1)==k, 2)+1;
                    end
            end
            
            
            switch alg
                case "T-UCB-LKM"
                    %a(t) = T_UCB_LKM_(Q_tild,Q_tild_,Q_und, N, req, c_t, t-1);
                    %tstart = tic;
                    %a(t) = T_UCB_LKM(N, a, c_t, y, delta, t-1, N_c{c_ind});
                    a(t) = T_UCB_LKM(N, a, c_t, y, delta, t-1, N_tild);
                    %a(t) = T_UCB_LKM__(N, a(1:t-1), c_t, c, y, delta, t-1, N_c{c_ind}, N_tild);
                    %tend = toc(tstart);
                    a_t = a(t);
                
                case "LKMUCB"
                 %% LKMUCB   
                    count(c_ind)=count(c_ind)+1;
                    if count(c_ind)>K
                        count(c_ind)=1;
                    end
                    %aa = LKMUCB(c_ind, m, epoch, N, a, c_t, y, delta, Time);
                    
                    %j_id = c_ind;

    
                    if mod(t,(K*m))==0 && L_a(j_id)==0
                        %L_a(j_id) = LKMUCB(j_id, m, epoch, N, a, req(j_id), y, delta, t, Time);
                        L_a(j_id) = LKMUCB(j_id, m, epoch, N, a, req(j_id), y, delta, t, Time);
                        epoch = epoch+1;
                        %count(c_ind)=0;
                        if (j_id>0) &&(L_a(j_id)~=0)
                        %if (j_id<K) &&(L_a(j_id)~=0)
                            j_id=j_id-1;
                            %j_id=j_id+1;
                        end
                        if (j_id==0)
                        %if (j_id==K)
                            j_id=1;
                        end
                    end
  
                    %}
                    
                    %if c_t>=req(j_id)
                    if L_a(c_ind) ~=0 || j_id < c_ind
                        a(t) = L_a(c_ind); 
                    else
                        a(t) = count(c_ind);
                    end
                    a_t = a(t);
  
                    
                case "LKMUCB-C"
                   F_tild = sum((X_obs(:,1:t-1) >= req(j_id)) & (jtg), 2)'./N_tild;
                   count(c_ind)=count(c_ind)+1;
                    if count(c_ind)>K
                        count(c_ind)=1;
                    end
 
                    if mod(t,(K*m))==0 && L_a(j_id)==0
                        L_a(j_id) = LKMUCBC(j_id, m, epoch, F_tild, Time);
                        epoch = epoch+1;
                        if (j_id>0) &&(L_a(j_id)~=0)
                            j_id=j_id-1;
                        end
                        if (j_id==0)
                            j_id=1;
                        end
                    end
  
                    %}
                    
                    %if c_t>=req(j_id)
                    if L_a(c_ind) ~=0 || j_id < c_ind
                        a(t) = L_a(c_ind); 
                    else
                        a(t) = count(c_ind);
                    end
                    a_t = a(t);
                        
                case "T-UCB"
                    if usew && t>wsize
                        Nw = N-(Nt(:,t-wsize))';
                        F = sum((X(:,t-wsize:t-1) >= c(t)), 2)'./Nw;
                        a(t) = T_UCB(F,Nw,wsize-1);
                    else 
                        F = sum((X(:,1:t-1) >= c(t)), 2)'./N;
                        %F = sum((X(:,1:t-1) >= c(t)), 2)'./N_c{c_ind};
                        a(t) = T_UCB_(F,N,t-1,N_c{c_ind},a,c);
                    end
                    
                case "T-UCB-C"
                    if usew && t>wsize
                        F_tild = sum((X_obs(:,t-wsize:t-1) >= c(t)) & (jtg), 2)'./N_tild;
                        a(t) = T_UCB(F_tild,N_tild,wsize-1);
                    else 
                        F_tild = sum((X_obs(:,1:t-1) >= c(t)) & (jtg), 2)'./N_tild;
                        %a(t) = T_UCB(F_tild,N_tild,t-1);
                        a(t) = T_UCB_(F_tild,N_tild,t-1,N_c{c_ind},a,c);
                    end
                    
            end
            

        end
        
        if Rayl
        % For Rayleigh channels
            Env = [Env x_r(:,t)];
        
            for k=1:K
                ind_c(k) = sum(xccdf(k,:)<=c(t),2);
                if ind_c(k)~=0
                    nu_c(k) = yccdf(k,ind_c(k));
                else
                    nu_c(k) = 1;
                end
            end
        else
        % draw Env (channel rate) iid
            Env = [Env unifrnd(chanrange(:,1),chanrange(:,2))];
            nu_c = ((chanrange(:,2)-c(t))./(chanrange(:,2)-chanrange(:,1)))';
        end


        [~,as(t)] = max(nu_c);
        
        %Envc = Env((c(t)>chanparam(:,1)&c(t)<chanparam(:,2))',t);
        
        X(a(t),t) = Env(a(t),t);
        r = X(a(t),t) >= c(t);
        
        rs = Env(as(t),t) > c(t);
        
        delta(t) = c_t<=X(a(t),t);
        %{
        if t==1000
            Xnz = X(2,:);
            Xnz = Xnz(Xnz~=0);
            figure
            histogram(Xnz,10)
            disp()
        end
        %}
        reward = [reward r];
        N(a(t)) = N(a(t)) + 1;
        N_c{c_ind}(a(t)) = N_c{c_ind}(a(t)) + 1;
        Nt(:,t) = Nt(:,max([t-1 1]));
        Nt(a(t),t) = Nt(a(t),t)+1;
        
        %% update T-UCB-LKM variables
        y(t) = max(c(t),X(a(t),t));
        
        %{
        for cc=1:length(req)
            Q_tild(a(t),cc) = Q_tild(a(t),cc) + (y(t)>req(cc))*(c(t)<=X(a(t),t));
            Q_tild_(a(t),cc) = Q_tild_(a(t),cc) + (y(t)>=req(cc))*(c(t)<=X(a(t),t));
            Q_und(a(t),cc) =  Q_und(a(t),cc) + (y(t)>req(cc))*(c(t)>X(a(t),t));
        end
        %}
         %% 
        if (r)
            X_obs(a(t),t) = X(a(t),t);
        else
            f(a(t),t) = 1;  % record zero outcomes (failure) (c_s>c_t)
        end
        
        %if usew && t>wsize
        %    X_obs(:,1:t-wsize) = 0;
        %    X(:,1:t-wsize) = 0;
        %end
        
        %PulledArm = [PulledArm a(t)];
        S(a(t)) = S(a(t)) + r;
        
        %S_c{c_ind}(a(t)) = S_c{c_ind}(a(t)) + r;
        
        gap(t) = rs-r;
        
        %T_path = [T_path T(2)];

        %% Compute Cumulative Regret
        regret(t) = sum(gap, 'all');
        
        %regret(t) = sum((max(Env,[],'all') - Env)'.*N, 'all');
        if regret(t)>1000 && alg=="LKMUCB"
            %disp("regret exploded")  
            explod = true;
            %break
        end
        
        %regret(t) = t*max(Env) - sum(reward);
        
        %if mod(t,100)==0 && alg=="T-UCB-LKM"
 %           disp(tend)
        %end
    end
    
end