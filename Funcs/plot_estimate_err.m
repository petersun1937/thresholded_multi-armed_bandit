function [] = plot_estimate_err(F_diff_cell, c, ch, req, Algs)    

    figure
    plot(mean(F_diff_cell{ch,1},1),'b', 'LineWidth',1.5);
    hold on
    title("c_t = "+num2str(req(c))+", Ch"+num2str(ch))
    plot(mean(F_diff_cell{ch,2},1),'k', 'LineWidth',1.5);
    plot(mean(F_diff_cell{ch,3},1),'r', 'LineWidth',1.5);
    grid on
    xlabel('Samples')
    ylabel('Estimation difference')
    leg = legend(Algs(1),Algs(2),Algs(3),'Interpreter','latex');
    leg.FontSize = 14;
    hold off
    
    
end