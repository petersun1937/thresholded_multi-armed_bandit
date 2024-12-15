function [bound, ui, regret_ub] = UCB_bound(Env,n,p1,p2) 

[~,is] = max(Env(1,:));
[K,I]=size(Env);
regret_ub = 0;

ui=0;


for k=1:numel(Env)
    Del(k)=(max(Env,[],'all')-Env(k));
    if (Del(k)~=0)
        ui = ceil(8*log(n)/Del(k)^2);
        bound(k) = ui+(1+n*exp(-(ui*0.5^2*Del(k)^2)/2));
        regret_ub = regret_ub+Del(k)*bound(k);
    end
end
%}


%% Bounding T_i,j
%Del=(max(Env,[],'all')-Env(p1,p2));
%u =ceil(8*log(n)/Del^2);
%bound = u+1;

%ui=0;

%% Timeframe UCB regret

for i=1:I
    Del(1,i)=(max(Env,[],'all')-Env(1,i));
    ui=0;
    if (i~=is)
        for j=1:K
            Del_i(j)=(Env(j,is)-Env(j,i));
            ui = ui+ceil(8*log(n)/(Del_i(j))^2);
        end
        bound(1,i) = ui+3*K;
        regret_ub = regret_ub+Del(1,i)*bound(1,i);
    else
        for j=1:K
        Del(j,i)=(max(Env,[],'all')-Env(j,i));
        
        if (Del(j,i)~=0)
            u = ceil(8*log(n)/Del(j,i)^2);
            bound(j,i) = u+1;
            regret_ub = regret_ub+Del(j,i)*bound(j,i);
        end
        end
    end
end
%}
%{
for i=1:I
    for j=1:K
        ui = ceil(8*log(n)/(Del_i(j))^2);
    end
    for j=1:K
        Del(j,i)=(max(Env,[],'all')-Env(j,i));
        if (i~=is)
            Del_i(j)=(Env(j,is)-Env(j,i));
            bound(j,i) = ui+3*K;
            regret_ub = regret_ub+Del(j,i)*bound(j,i);
        else
            if (Del(j,i)~=0)
                u = ceil(8*log(n)/Del(j,i)^2);
                bound(j,i) = u+1;
                regret_ub = regret_ub+Del(j,i)*bound(j,i);
            end
        end
    end
end
%}
%%
%{
for k=1:numel(Env)
    Del(k)=(max(Env,[],'all')-Env(k));
    u(k) = ceil(8*log(n1)/Del(k));UCB_bound
    bound(k) = u(k)+n2*(n2*delta+exp(-(u(k)*0.5^2*Del(k)^2)/2));
end
%}