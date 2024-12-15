clear
%{
load("T-UCB-E_K=2_capped.mat")
cumreg_ = zeros(3,T);  CI95_ = cell(1,3);  std_ = zeros(3,T);
cumreg_(1,:) = cumreg(1,:); CI95_{1} = CI95{1}; std_(1,:) = std(1,:);

load("T-UCB-E_K=4_capped.mat")
cumreg_(2,:) = cumreg(1,:); CI95_{2} = CI95{1}; std_(2,:) = std(1,:);

load("T-UCB-E_K=6_capped.mat")
cumreg_(3,:) = cumreg(1,:); CI95_{3} = CI95{1}; std_(3,:) = std(1,:);

PlotRegret3(cumreg_(1,:),cumreg_(2,:),cumreg_(3,:),std_(1,:),std_(2,:),std_(3,:),...
   CI95_{1},CI95_{2},CI95_{3},"K=2", "K=4", "K=6");

%}

load("T-UCB-E_K=2_contct.mat")
cumreg_ = zeros(2,T);  CI95_ = cell(1,2);  std_ = zeros(2,T);
cumreg_(1,:) = cumreg(1,:); CI95_{1} = CI95{1}; std_(1,:) = std(1,:);

load("T-UCB-E_K=4_contct.mat")
cumreg_(2,:) = cumreg(1,:); CI95_{2} = CI95{1}; std_(2,:) = std(1,:);

PlotRegret2(cumreg_(1,:),cumreg_(2,:),std_(1,:),std_(2,:),...
   CI95_{1},CI95_{2},"K=2", "K=4");
%}