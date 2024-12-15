function [reward, regret, T_path, k, timer] = Classic(Env, Time, alg)

    K = length(Env);
    mu = zeros(1,K);
    l = zeros(1,K);
    T = zeros(1,K);  S = zeros(1,K);    F = zeros(1,K);
    reward = [];    %SelectedArm = [];
    regret = zeros(1,Time);
    %asympregret = zeros(1,Time);
    
    T_path = [];
    timer = [];         % timer
    
    
    for t = 1:Time
        tic;
        
        
        if t < K+1
            k(t) = t;  % Or arms within the neighborhood of initial L(t)
        else

            
        % Threshold for determining to choose current leader or not
 
        switch alg
            case "KLUCB"
                k(t) = F_KLUCB(mu,T,t);
            case "UCB"
                k(t) = F_UCB(mu,T,1/t);
            case "TS"
                k(t) = F_TS(S,F);
        end

        end
        
    
        Z = rand() < Env(k(t));

        %[ExpectedMeans, NbrPlayArm, gainKLUCB, ArmsPlayed]= UCB1_ReceiveReward(ExpectedMeans, NbrPlayArm, reward, ArmToPlay, gainKLUCB, ArmsPlayed); % Update UCB parameters using the reward received at time t.
        reward = [reward Z];


        T(k(t)) = T(k(t)) + 1;


        %SelectedArm = [SelectedArm k(t)];


        S(k(t)) = S(k(t)) + Z;
        F(k(t)) = F(k(t)) + ~Z;
       % mu_h = S./T;
       % ExpectedMeans(Is) = (ExpectedMeans(Is)*T(Is) + reward)./(T(Is)+1);
        mu(k(t)) = (S(k(t)))./(T(k(t)));
        
        tend = toc;
        timer = [timer tend];
        
        T_path = [T_path T(2)];
        
        %% Compute Cumulative Regret
        regret(t) = sum((max(Env,[],'all') - Env)'.*T, 'all');
        %regret(t) = t*max(Env) - sum(reward);
        
        %asympregret(t) =(max(Env) - Env(k(t)));
        
        
    end
    
end