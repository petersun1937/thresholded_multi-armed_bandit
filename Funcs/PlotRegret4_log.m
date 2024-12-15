function PlotRegret4_log(regret1,regret2,regret3,regret4,std1,std2,std3,std4,CI95_1,CI95_2,CI95_3,CI95_4,Alg1,Alg2,Alg3,Alg4)
T = size(regret1,2);

% Plot 95% Confidence Intervals of all experiments
figure
loglog(mean(regret1,1),'k', 'LineWidth',2);
hold on
grid on
%patch('XData',[1:T fliplr(1:T)],'YData',[CI95_1(1,:) fliplr(CI95_1(2,:))], 'facecolor','black',...
%        'edgecolor','none', ...
 %       'facealpha', 0.3)
loglog(mean(regret2,1), 'b', 'LineStyle', '--', 'LineWidth',2);
%patch('XData',[1:T fliplr(1:T)],'YData',[CI95_2(1,:) fliplr(CI95_2(2,:))], 'facecolor','blue',...
 %       'edgecolor','none', ...
 %       'facealpha', 0.3)

loglog(mean(regret3,1),'r', 'LineStyle', '-.', 'LineWidth',2);
%patch('XData',[1:T fliplr(1:T)],'YData',[CI95_3(1,:) fliplr(CI95_3(2,:))], 'facecolor','red',...
%        'edgecolor','none', ...
 %       'facealpha', 0.3)

loglog(mean(regret4,1), 'color',[0.4660 0.6740 0.1880], 'LineStyle', ':', 'LineWidth',2);
%patch('XData',[1:T fliplr(1:T)],'YData',[CI95_4(1,:) fliplr(CI95_4(2,:))], 'facecolor',[0.4660 0.6740 0.1880],...
%        'edgecolor','none', ...
%        'facealpha', 0.3)
    
%grid on

xlabel('Time slot')
ylabel('Cumulative regret')
%leg = legend(Alg1,'',...
 %   Alg2,'', Alg3,'',Alg4,'Interpreter','latex');

leg = legend(Alg1,...
    Alg2, Alg3,Alg4,'Interpreter','latex');
leg.FontSize = 14;

end