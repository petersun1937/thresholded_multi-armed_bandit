function PlotRegret(regret,std,CI95,Alg)
T = size(regret,2);
% Plot the mean of cumulative regret of all experiments
%{
figure
plot(mean(regret,1),'k', 'LineWidth',1.5);
hold on
grid on
xlabel('Time slot')
ylabel('Cumulative regret')
legend(Alg)
%}
% Plot Standard Deviation of all experiments
%{
figure
plot(std,'k', 'LineWidth',1.5);
grid on
xlabel('Time slot')
ylabel('Standard Deviation')
legend(Alg)
%}
% Plot 95% Confidence Intervals of all experiments
figure
plot(mean(regret,1),'k', 'LineWidth',1.5);
hold on
patch('XData',[1:T fliplr(1:T)],'YData',[CI95(1,:) fliplr(CI95(2,:))], 'facecolor','blue',...
        'edgecolor','none', ...
        'facealpha', 0.3)
grid on
xlabel('Time slot')
ylabel('Cumulative regret')
legend(Alg,"95% Confidence")

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