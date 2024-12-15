function PlotRegret2(regret1,regret2,std1,std2,CI95_1,CI95_2,Alg1,Alg2)
T = size(regret1,2);
% Plot the mean of cumulative regret of all experiments
%{
figure
plot(mean(regret1,1),'k', 'LineWidth',1.5);
hold on
plot(mean(regret2,1),'r', 'LineWidth',1.5);
grid on
xlabel('Time slot')
ylabel('Cumulative regret')
legend(Alg1,Alg2)
%}
% Plot Standard Deviation of all experiments
figure
plot(std1,'k', 'LineWidth',2);
hold on
plot(std2,'r', 'LineStyle', '--', 'LineWidth',2);
grid on
xlabel('Time slot')
ylabel('Standard Deviation')
legend(Alg1,Alg2)

% Plot 95% Confidence Intervals of all experiments
figure
plot(mean(regret1,1),'k', 'LineWidth',2);
hold on
patch('XData',[1:T fliplr(1:T)],'YData',[CI95_1(1,:) fliplr(CI95_1(2,:))], 'facecolor','blue',...
        'edgecolor','none', ...
        'facealpha', 0.3)
plot(mean(regret2,1),'r', 'LineStyle', '--', 'LineWidth',2);
patch('XData',[1:T fliplr(1:T)],'YData',[CI95_2(1,:) fliplr(CI95_2(2,:))], 'facecolor','red',...
        'edgecolor','none', ...
        'facealpha', 0.3)

grid on
xlabel('Time slot')
ylabel('Cumulative regret')

leg = legend(Alg1,'',Alg2,'','Interpreter','latex');
leg.FontSize = 14;

end


%{
figure
plot(mean(regret_DTS,1),'b', 'LineWidth',1.5);
hold on
patch('XData',[1:T fliplr(1:T)],'YData',[CI95_DTS(1,:) fliplr(CI95_DTS(2,:))], 'facecolor','blue',...
        'edgecolor','none', ...
        'facealpha', 0.3)
plot(mean(regret_DKLUCB,1),'r', 'LineWidth',1.5);
patch('XData',[1:T fliplr(1:T)],'YData',[CI95_DKLUCB(1,:) fliplr(CI95_DKLUCB(2,:))], 'facecolor','red',...
        'edgecolor','none', ...
        'facealpha', 0.3)

grid on
xlabel('Time slot')
ylabel('Cumulative regret')
legend("Two-level Feedback TS" ,"95% Confidence TS",...
    "Two-level Feedback KLUCB","95% Confidence KLUCB")

figure
plot(std_DTS,'b', 'LineWidth',1.5);
hold on
plot(std_DKLUCB,'r', 'LineWidth',1.5);
grid on
xlabel('Time slot')
ylabel('Standard Deviation')
legend("Two-level Feedback TS","Two-level Feedback KLUCB")
%}