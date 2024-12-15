function PlotRegret3(regret1,regret2,regret3,std1,std2,std3,CI95_1,CI95_2,CI95_3,Alg1,Alg2,Alg3)
T = size(regret1,2);
%{
figure
plot(mean(regret1,1),'k', 'LineWidth',1.5);
hold on
plot(mean(regret2,1),'r', 'LineWidth',1.5);
plot(mean(regret3,1),'b', 'LineWidth',1.5);
grid on
xlabel('Time slot')
ylabel('Cumulative regret')
legend(Alg1,Alg2,Alg3)
%}

% Plot Standard Deviation of all experiments
%{
figure
plot(std1,'k', 'LineWidth',1.5);
hold on
plot(std2,'r', 'LineWidth',1.5);
plot(std3,'b', 'LineWidth',1.5);
grid on
xlabel('Time slot')
ylabel('Standard Deviation')
legend(Alg1,Alg2,Alg3)
%}
% Plot 95% Confidence Intervals of all experiments
figure
plot(mean(regret1,1),'k', 'LineWidth',2);
hold on
grid on
patch('XData',[1:T fliplr(1:T)],'YData',[CI95_1(1,:) fliplr(CI95_1(2,:))], 'facecolor','black',...
        'edgecolor','none', ...
        'facealpha', 0.3)
plot(mean(regret2,1),'b', 'LineStyle', '--', 'LineWidth',2);
patch('XData',[1:T fliplr(1:T)],'YData',[CI95_2(1,:) fliplr(CI95_2(2,:))], 'facecolor','blue',...
        'edgecolor','none', ...
        'facealpha', 0.3)
plot(mean(regret3,1),'r', 'LineStyle', '-.', 'LineWidth',2);
patch('XData',[1:T fliplr(1:T)],'YData',[CI95_3(1,:) fliplr(CI95_3(2,:))], 'facecolor','red',...
        'edgecolor','none', ...
        'facealpha', 0.3)
    %% If plot takes too long
    %{
plot([1 10:10:300000],mean(regret1,1),'k', 'LineWidth',2);
hold on
patch('XData',[[1 10:10:300000] fliplr([1 10:10:300000])],'YData',[CI95_1(1,:) fliplr(CI95_1(2,:))], 'facecolor','black',...
        'edgecolor','none', ...
        'facealpha', 0.3)
plot([1 10:10:300000],mean(regret2,1),'b', 'LineStyle', '--', 'LineWidth',2);
patch('XData',[[1 10:10:300000] fliplr([1 10:10:300000])],'YData',[CI95_2(1,:) fliplr(CI95_2(2,:))], 'facecolor','blue',...
        'edgecolor','none', ...
        'facealpha', 0.3)
plot([1 10:10:300000],mean(regret3,1),'r', 'LineStyle', '-.', 'LineWidth',2);
patch('XData',[[1 10:10:300000] fliplr([1 10:10:300000])],'YData',[CI95_3(1,:) fliplr(CI95_3(2,:))], 'facecolor','red',...
        'edgecolor','none', ...
        'facealpha', 0.3)
    %}
    %%
%grid on
xlabel('Time slot')
ylabel('Cumulative regret')
%legend(Alg1,"95% Confidence "+Alg1,...
%    Alg2,"95% Confidence "+Alg2, Alg3,"95% Confidence "+Alg3)
leg = legend(Alg1,"",Alg2,"", Alg3,"",'Interpreter','latex');
leg.FontSize = 14;

end