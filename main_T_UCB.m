clear

addpath('Algs')
addpath('Funcs')
addpath('Decision')

%% Inputs and parameters
%req = [1/2, 5/8];                  % For uniform distributed channels
%req = [3/8, 1/2, 5/8];                  % set of 3
req = [3/8, 1/2, 5/8, 3/4];            % set of 4

%req = [1/3, 1/2, 5/8, 3/4];            % set of 4 (real)
%req = [1/3, 1/2, 7/8];                 % set of 3 (alt)

%req = [1/3, 1/2, 5/8, 3/4, 5/6];            % set of 5 (real)
contreq = false;

%req = [1/2, 5/8];        contreq = true;    

%req = [5.8 6.4 7.4 8 9.6 10.4];    % case 1 alt

%req = [6.4 7.2 8 8.8 9.6 10.4];    % case 1
%req = [8 8.8 9.6 10.4];                 % case 2
%req = [9.6 10.4];              % case 3

ChanRateParam = [3/8, 3/4; 0, 1];                   % K=2
%ChanRateParam = [3/8,3/4; 0, 1; 0,3/4; 0,7/8];     % K=4
%ChanRateParam = [3/8,3/4; 0, 1; 0,3/4; 0,7/8; 1/8,5/8; 1/8,3/4];  % K=6
%ChanRateParam = [3/8,3/4; 0, 1; 0,3/4; 0,7/8; 1/8,5/8; 1/8,3/4; 1/4,3/4; 1/4,5/8];  % K=8

Ch_num = size(ChanRateParam,1);
  
%AvgThruput = normpdf(-2:0.05:4, 1, 1)*2;     %K=121, normal dist.

T = 100e3;               % Time horizon
Num_Trials = 35;        % number of trials
UseRayleigh = 0;        % Use Rayleigh channels

UseWindow = 0; wsize = 0;    % Use sliding window (unstable, leave zero)

% Choose the decision algorithms (T-UCB, T-UCB-C, T-UCB-E, T-UCB-LKM)
Algs = ["T-UCB" "T-UCB-C" "T-UCB-LKM" "LKMUCB"]; %"T-UCB" "T-UCB-C" "T-UCB-LKM"
Num_Algs = numel(Algs);
if(UseRayleigh) Ch_num = 3; end

%% Initialization
SelectedArms       = cell(Num_Trials,Num_Algs);

reward  = cell(1,Num_Algs);
F_diff_cell1  = cell(Ch_num,Num_Algs); F_diff_cell2  = cell(Ch_num,Num_Algs);
F_diff_cell3  = cell(Ch_num,Num_Algs); F_diff_cell4  = cell(Ch_num,Num_Algs);
F_diff_cell5  = cell(Ch_num,Num_Algs); F_diff_cell6  = cell(Ch_num,Num_Algs);
regret = cell(1,Num_Algs);
T_paths = cell(1,Num_Algs); T_paths2 = cell(1,Num_Algs);
[K]=size(ChanRateParam,1);

%% Run Algorithms for Num_Trials Times
for trial = 1:Num_Trials
    disp(trial)
    for alg = 1:Num_Algs        % Run each algorithm
        disp(Algs(alg))
    %% T-UCB
    tic
    [X, reg, ~, Arm, explod] = RunAlg_epoch(ChanRateParam, T, Algs(alg), req, UseRayleigh, contreq, UseWindow, wsize);
    %[X, reg, ~, Arm, explod, F_diff] = RunAlg_sample(ChanRateParam, T, Algs(alg), req, UseRayleigh, contreq, UseWindow, wsize);
    %[X, reg, ~, Arm, explod] = RunAlg(ChanRateParam, T, Algs(alg), req, UseRayleigh, contreq, UseWindow, wsize);
    toc
    %% Classic algs
    
    %[~, U_KL_reg, ~, U_KL_Arm, timer1] = KLUCB(AvgThruput, T, "KLUCB");  
    %[~, U_UCB_reg, ~, U_UCB_Arm, timer2] = UCB(AvgThruput, T, "UCB");
    %[~, U_TS_reg, ~, U_TS_Arm, timer3] = Classic(AvgThruput, T, "TS");
    
    
        %% Update records
        
    %if ~explod
    SelectedArms{trial,alg} = Arm;
    
    reward{alg}       = [reward{alg}; X];
    % Cumulative regret
    regret{alg}       = [regret{alg}; reg];  
    %end
        %if exist('T_paths','var')
            %T_paths{alg}       = [T_paths{alg}; T_path]; 
            %T_paths2{alg}       = [T_paths2{alg}; T_path2]; 
       % end
    
       %%For plotting estimation errors
    %{
       for ch=1:Ch_num
       
            F_diff_cell1{ch,alg}  = [F_diff_cell1{ch,alg}; F_diff{1}(1:2000,ch)'];   %F_diff{c_ind}(a)
            F_diff_cell2{ch,alg}  = [F_diff_cell2{ch,alg}; F_diff{2}(1:2000,ch)'];   
            %F_diff_cell3{ch,alg}  = [F_diff_cell3{ch,alg}; F_diff{3}(1:2000,ch)'];   
            %F_diff_cell4{ch,alg}  = [F_diff_cell4{ch,alg}; F_diff{4}(1:2000,ch)'];   
       end
    %}
    end
    
    if trial>2
        %save("T-UCB-C_alpha=0.2_c2_300k_t"+string(trial)+".mat")
        %save("LKM_new_alpha=2_c1_100k_t"+string(trial)+".mat")
        %save("LKM_Ntild_Rayleigh_case3_10e4_t"+string(trial)+".mat")
        %save("new_Rayleigh_c1_300k_t"+string(trial)+".mat")
        %save("new_K=8_c=4_t"+string(trial)+".mat")
        %save("new_LKM_Rayleigh_c3_300k_t"+string(trial)+".mat")
    end
end


%% Compute and plot regret and statistics
for alg = 1:Num_Algs
    [cumreg(alg,:), std(alg,:), CI95{alg}] = RegretAnalysis([], regret{alg}, Num_Trials);
    
    
    
    %figure
    %plot(mean(T_paths{alg},1),'k', 'LineWidth',1.5);
    %plot(T_paths{alg}(1,:),'k', 'LineWidth',1.5);
    %grid on
    %{
    xlabel('Time slot')
    ylabel('T paths')
    hold on
    plot(mean(T_paths2{alg},1),'b', 'LineWidth',1.5);
    %plot(T_paths2{alg}(1,:),'b', 'LineWidth',1.5);
    hold off
    %}
end

    %{
    figure
    plot(mean(F_diff_cell1{1,1},1),'b', 'LineWidth',1.5);
    hold on
    title("c_t = "+num2str(req(1)))
    plot(mean(F_diff_cell1{2,2},1),'k', 'LineWidth',1.5);
    plot(mean(F_diff_cell1{1,3},1),'r', 'LineWidth',1.5);
    grid on
    xlabel('Samples')
    ylabel('Estimation difference')
    leg = legend(Algs(1),Algs(2),Algs(3),'Interpreter','latex');
    leg.FontSize = 14;
    hold off
    %}
%{
for ch=1:Ch_num
    plot_estimate_err(F_diff_cell1, 1, ch, req, Algs) 
    plot_estimate_err(F_diff_cell2, 2, ch, req, Algs) 
    %plot_estimate_err(F_diff_cell3, 3, ch, req, Algs) 
    %plot_estimate_err(F_diff_cell4, 4, ch, req, Algs) 

end
    %}
%save("Rayleigh_K="+string(K)+"_c="+string(length(req))+"_uncapped_t50.mat")

%NumArms = [numel(AvgThruput{1}) numel(AvgThruput{2}) numel(AvgThruput{3}) numel(AvgThruput{4})];
%% Compute and plot regret and statistics

switch Num_Algs
    case 1
        PlotRegret(cumreg(1,:),std(1,:),CI95{1},...
            Algs(1))
    case 2
        PlotRegret2_log(cumreg(1,:),cumreg(2,:),std(1,:),std(2,:),CI95{1},CI95{2},...
             Algs(1), Algs(2))
    case 3
        PlotRegret3(cumreg(1,:),cumreg(2,:),cumreg(3,:),std(1,:),std(2,:),std(3,:),...
           CI95{1},CI95{2},CI95{3},Algs(1), Algs(2), Algs(3))
    case 4
        PlotRegret4_log(cumreg(1,:),cumreg(2,:),cumreg(3,:),cumreg(4,:),std(1,:),std(2,:),std(3,:),std(4,:),...
           CI95{1},CI95{2},CI95{3},CI95{4},Algs(1), Algs(2), Algs(3), Algs(4))
end
