function [Reg_lb] = Lower_bound(Env,n) 

[~,is] = max(Env(1,:));
[K,I]=size(Env);
LB = zeros(K,I);
C = zeros(1,I);
ui=0;

%}

%{
for i=1:I
    %Del(1,i)=(max(Env,[],'all')-Env(1,i));
    ui=0;
    if (i~=is)
        for j=1:K
            CI = KLDiv(Env(j,i),Env(j,is));
            C(i) = C(i) + 1/CI;
        end
        for j=1:K
            LB(j,i) = C(i);
        end
        
    else
        for j=1:K
            if (max(Env,[],'all')-Env(j,i)~=0)
                CI = KLDiv(Env(j,i),max(Env,[],'all'));
                LB(j,i) = 1/CI;
            end
        end
    end
end

Reg_lb = 0;
for k=1:numel(Env)
    Del(k)=(max(Env,[],'all')-Env(k));
    if (Del(k)~=0)
        Reg_lb = Reg_lb + Del(k)*LB(k);
    end
end

end
%}


%% Lai Robbins

Reg_lb = 0;
for k=1:numel(Env)
    Del(k)=(max(Env,[],'all')-Env(k));
    if (Del(k)~=0)
        CI(k) = KLDiv(Env(k),max(Env,[],'all'));
        LB(k) = 1/CI(k);
        Reg_lb = Reg_lb + Del(k)*LB(k);
    end
end

end

%}
