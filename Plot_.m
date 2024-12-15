clear
addpath('Funcs')


%{
load("new_K=2_c=4_t30.mat")
cumreg_ = zeros(3,T);  CI95_ = cell(1,3);  std_ = zeros(3,T);
cumreg_(1,:) = cumreg(1,:); CI95_{1} = CI95{1}; std_(1,:) = std(1,:);

load("new_K=4_c=4_t30.mat")
cumreg_(2,:) = cumreg(1,:); CI95_{2} = CI95{1}; std_(2,:) = std(1,:);

load("new_K=6_c=4_t30.mat")
cumreg_(3,:) = cumreg(1,:); CI95_{3} = CI95{1}; std_(3,:) = std(1,:);

%PlotRegret3(cumreg_(1,:),cumreg_(2,:),cumreg_(3,:),std_(1,:),std_(2,:),std_(3,:),...
%   CI95_{1},CI95_{2},CI95_{3},"Case 1", "Case 2", "Case 3");

%}

load("new_Rayleigh_c1_300k_t10.mat")
cumreg_ = zeros(2,T);  CI95_ = cell(1,2);  std_ = zeros(2,T);
cumreg_(1,:) = cumreg(3,:); CI95_{1} = CI95{3}; std_(1,:) = std(3,:);

load("new_Rayleigh_c2_300k_t10.mat")
cumreg_(2,:) = cumreg(3,:); CI95_{2} = CI95{3}; std_(2,:) = std(3,:);

load("new_Rayleigh_c3_300k_t10.mat")
cumreg_(3,:) = cumreg(3,:); CI95_{3} = CI95{3}; std_(3,:) = std(3,:);

PlotRegret3(cumreg_(1,:),cumreg_(2,:),cumreg_(3,:),std_(1,:),std_(2,:),...
   std_(3,:),CI95_{1},CI95_{2},CI95_{3},"Case 1", "Case 2", "Case 3");
%}
%{
load("new_K=8_c=4_t30.mat")
cumreg_(4,:) = cumreg(1,:); CI95_{4} = CI95{1}; std_(4,:) = std(1,:);

PlotRegret4(cumreg_(1,:),cumreg_(2,:),cumreg_(3,:),cumreg_(4,:),[],[],[],[],...
   CI95_{1},CI95_{2},CI95_{3},CI95_{4},"$|S_2|=0$", "$|S_2|=2$", "$|S_2|=4$","$|S_2|=6$");
%
%}


%% If plot takes too long
%{
load("Rayleigh_c11_uncapped_t15_300.mat")
cumreg_ = zeros(3,30001);  CI95_ = cell(1,3);  std_ = zeros(3,30001);
cumreg_(1,:) = cumreg(2,[1 10:10:300000]); CI95_{1} = [CI95{2}(1,[1 10:10:300000]);CI95{2}(2,[1 10:10:300000])]; std_(1,:) = std(2,[1 10:10:300000]);
load("Rayleigh_c22_uncapped_t15_300.mat")
cumreg_(2,:) = cumreg(2,[1 10:10:300000]); CI95_{2} = [CI95{2}(1,[1 10:10:300000]);CI95{2}(2,[1 10:10:300000])]; std_(2,:) = std(2,[1 10:10:300000]);
load("Rayleigh_c33_uncapped_t15_300.mat")
cumreg_(3,:) = cumreg(2,[1 10:10:300000]); CI95_{3} = [CI95{2}(1,[1 10:10:300000]);CI95{2}(2,[1 10:10:300000])]; std_(3,:) = std(2,[1 10:10:300000]);
PlotRegret3(cumreg_(1,:),cumreg_(2,:),cumreg_(3,:),std_(1,:),std_(2,:),std_(3,:),...
   CI95_{1},CI95_{2},CI95_{3},"Case 1", "Case 2", "Case 3");
%}

%%
%savefig('T-UCB-C_c=3_capped_t50.fig')
%saveas(gcf,['T-UCB-C_c=3_capped_t50.png']);

%f = gcf;
%exportgraphics(gcf,'T-UCB-LKM_Rayleigh_new.png','Resolution',300)