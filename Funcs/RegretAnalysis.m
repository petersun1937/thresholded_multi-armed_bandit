function [regret_mean, rSTD, rCI95] = RegretAnalysis(Env,regret,Num_Trials)

%Time = size(X,2);
%K = length(Env);

regret_mean = mean(regret,1);

% Standard deviation of the regret
rSTD = std(regret,1);
% Standard error of the mean
SEM = rSTD/sqrt(Num_Trials);
% 95% confidence interval
rCI95 = [mean(regret_mean,1)-1.96*SEM; mean(regret_mean,1)+1.96*SEM]; 

end
