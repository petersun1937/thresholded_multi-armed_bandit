function [reward, regret, T_path, a, explod] = RunAlg(chanrange, Time, alg, req, Rayl, contreq, usew, wsize)
    explod = false;
    if Rayl
        K=3;
        disp("Using Rayleigh channels")
    else
        K = size(chanrange,1);
    end
    
    N = zeros(1,K);  S = zeros(1,K); f = zeros(K,Time); Nt = zeros(K,Time); Nt(:,1)=1;
    X = zeros(K,Time); X_tild = zeros(K,Time); X_obs = zeros(K,Time);
    %Q_tild = zeros(K,length(req));   Q_und = zeros(K,length(req));
    %Q_tild_ = zeros(K,length(req));
    %S_c = cell(1,length(req)); 
    N_c = cell(1,length(req));
    reward = [];    %SelectedArm = [];
    regret = zeros(1,Time);
    T_path = [];
    timer = [];         % timer
    tend=0;
    Env = [];
    
    F = zeros(1,2);
    F_hat = zeros(K,Time); F_phi = zeros(K,Time); F_ = zeros(K,Time);
    % Compute distribution ground truth of channel coding rates
    nu = (chanrange(:,1)+chanrange(:,2))'./2;
    
    % Compute Rayleigh fading channel ground truth
    if Rayl
        [x_r,xccdf,yccdf] = Rayleigh_x(K,Time,[6 17 14],[19 11 2]);  %[6 17 14],[19 11 2]; [6 17 12],[20 10 2]
    end
    
    for k=1:length(req)
        %S_c{k} = zeros(size(N));
        N_c{k} = zeros(size(N))+1;
    end
    

    for t = 1:Time
    
    % draw c_t from iid uniform
    c_ind = randi(length(req));
    if ~contreq
        c(t) = req(c_ind);
        c_t = c(t);
    else
        c(t) = unifrnd(1/2, 5/8);
        c_t = c(t);
    end
        % Initialization
        if t < K+1
            a(t) = t;  
        %elseif   t < 2*K+1  
        %    a(t) = t-K;
        else
            switch alg
                case "T-UCB"
                    N_tild = zeros(1,K); 
                    ctg = c(1:t-1) <= c(t);
                    for k=1:K
                        N_tild(k) = sum((ctg) & a(1:t-1)==k, 2)+1;
                    end
                case "T-UCB-LKM"
                    N_tild = zeros(1,K); 
                    
                    ctg = c(1:t-1) <= c(t);

                    for k=1:K
                        %N_tild(k) = sum((ctg) & a(1:t-1)==k, 2)+1;
                        N_tild(k) = sum((ctg) & a(1:t-1)==k, 2);
                    end
                case "T-UCB-C"
                    N_tild = zeros(1,K); 
                    
                    if usew && t>wsize
                        ctg = c(t-wsize:t-1) <= c(t);
                    else
                        ctg = c(1:t-1) <= c(t);
                    end
                    
                    for k=1:K
                        %if usew && t>wsize
                        %    N_tild(k) = sum((ctg) & a(t-wsize:t-1)==k, 2)+1;
                        %else
                        %N_tild(k) = sum((ctg) & a(1:t-1)==k, 2)+1;
                        N_tild(k) = sum((ctg) & a(1:t-1)==k, 2);
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
            end
            
            
            switch alg
                case "T-UCB-LKM"
                    %a(t) = T_UCB_LKM_(Q_tild,Q_tild_,Q_und, N, req, c_t, t-1);
                    %tstart = tic;
                    %a(t) = T_UCB_LKM(N, a, c_t, y, delta, t-1, N_c{c_ind});
                    a(t) = T_UCB_LKM___(N, a, c_t, c, y, delta, t-1, N_c{c_ind}, N_tild);
                    %a(t) = T_UCB_LKM__(N, a(1:t-1), c_t, c, y, delta, t-1, N_c{c_ind}, N_tild);
                    %tend = toc(tstart);
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
                        F_tild = sum((X_obs(:,t-wsize:t-1) >= c(t)) & (ctg), 2)'./N_tild;
                        a(t) = T_UCB(F_tild,N_tild,wsize-1);
                    else 
                        F_tild = sum((X_obs(:,1:t-1) >= c(t)) & (ctg), 2)'./N_tild;
                        %a(t) = T_UCB(F_tild,N_tild,t-1);
                        a(t) = T_UCB_(F_tild,N_tild,t-1,N_c{c_ind},a,c);
                    end
                    
                case "T-UCB_C"
                    F = sum((X_obs(:,1:t-1) >= c(t)), 2)'./N;
                    a(t) = T_UCB(F,N,t-1);
                case "T-UCB-E"
                    N_tild = zeros(1,K); 
                    Ac = a(1:t-1).*(c(1:t-1) <= c(t));
                    for k=1:K
                        N_tild(k) = sum(Ac==k);
                    end
                    %if t>100
                        %F_hat(:,t-1) = Compute_F_hat_count(c(t),t-1,X_tild,N,F_hat(:,1:t-1),f(:,1:t-1),0);
                    
                        [F_hat(:,t-1),F_phi(:,t-1),F_(:,t-1)] = Compute_F_hat(c,t-1,X_obs,N,N_tild,Nt(:,1:t-1),...
                            F_hat(:,1:t-1),f(:,1:t-1),F_phi(:,1:t-1),F_(:,1:t-1));
                        F_hat_t = F_hat(:,t-1)';
                        a(t) = T_UCB(F_hat_t,N,t-1);
                       
                        
                    %else
                    %    F_tild = sum((X_tild(:,1:t-1) > c(t)) & (c(1:t-1) <= c(t)), 2)'./N_tild;
                    %    a(t) = T_UCB(F_tild,N,t-1);
                    %end
                %case "UCB"
                %    mu = S_c{c_ind}./N_c{c_ind};
                %    a(t) = T_UCB(mu,N_c{c_ind},t-1);
                    
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
        if regret(t)>350 && alg=="T-UCB-C"
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