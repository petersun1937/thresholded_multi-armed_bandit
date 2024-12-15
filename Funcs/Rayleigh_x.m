function [x,xxcdf,yccdf] = Rayleigh_x(K,T,mu,sigma)


% random channel gain and corresponding data rate

chan1 = sqrt(sigma(1)^2/2).*(randn(1,T)+1i*randn(1,T)) + mu(1);
chan2 = sqrt(sigma(2)^2/2).*(randn(1,T)+1i*randn(1,T)) + mu(2);
chan3 = sqrt(sigma(3)^2/2).*(randn(1,T)+1i*randn(1,T)) + mu(3);

g1 = abs(chan1).^2; % treat channel gain directly as SINR (equivlaent to noise variance = 1, tx power = 1
g2 = abs(chan2).^2;
g3 = abs(chan3).^2;

x = [log2(1+g1);log2(1+g2);log2(1+g3)];


% calculate empirical CDF and CCDF
[r1_cdf,x1] = cdfcalc(x(1,:));
r1_ccdf = 1-r1_cdf(1:end-1);
[r2_cdf,x2] = cdfcalc(x(2,:));
r2_ccdf = 1-r2_cdf(1:end-1);
[r3_cdf,x3] = cdfcalc(x(3,:));
r3_ccdf = 1-r3_cdf(1:end-1);

yccdf = [r1_ccdf';r2_ccdf';r3_ccdf'];
xxcdf = [x1'; x2'; x3'];

% save data
%save threshold.mat

% plot and save figure
%{
figure;
plot(x1,r1_ccdf,'k','LineWidth',2);
hold on;
grid on;
plot(x2,r2_ccdf,'--b','LineWidth',2);
plot(x3,r3_ccdf,'-.r','LineWidth',2);
xlabel('Channel capacity [bpcu]','FontSize',14);
ylabel('CCDF','FontSize',14);
lgd = legend('channel 1 ($\mu=6, \sigma=20$)', 'channel 2 ($\mu=17, \sigma=10$)', 'channel 3 ($\mu=12, \sigma=2$)','Interpreter','latex','Location','southwest');
lgd.FontSize = 14;
%title('CCDF of Rayleigh fading channel rates','FontSize',14);
%savefig('CCDF.fig')
%}


%{
    for i=1:K
        y(i,:) = normrnd(mu(i),sqrt(sigma(i)^2/2),[1 T]);
        z(i,:) = normrnd(0,sqrt(sigma(i)^2/2), [1 T]);
        %z(i,:) = normrnd(0,(sigma(i)^2/2), [1 T]);
    end

    SINR = abs(y).^2+abs(z).^2;
    x = log2(1+SINR);
    
    [ycdf_1,xcdf_1] = cdfcalc(x(1,:));
    yccdf_1 = 1-ycdf_1(1:end-1);
    
    [ycdf_2,xcdf_2] = cdfcalc(x(2,:));
    yccdf_2 = 1-ycdf_2(1:end-1);
    
    [ycdf_3,xcdf_3] = cdfcalc(x(3,:));
    yccdf_3 = 1-ycdf_3(1:end-1);

    xxcdf = [xcdf_1'; xcdf_2'; xcdf_3'];
    yccdf = [yccdf_1';yccdf_2';yccdf_3'];


    
    figure
    plot(xcdf_1,yccdf_1,'r','LineWidth',1.5);
    hold on
    grid on
    plot(xcdf_2,yccdf_2,'b','LineWidth',1.5);
    plot(xcdf_3,yccdf_3,'k','LineWidth',1.5);
    legend("mu=6","mu=17","mu=14")
    %{
    xx = 0.01:0.05:20;
    p = 1-chi2cdf(xx,2);
    figure
    hold on
    grid on
    plot(0.5.*log2(1+xx),p,'LineWidth',1.5);
    %}
    %}
end