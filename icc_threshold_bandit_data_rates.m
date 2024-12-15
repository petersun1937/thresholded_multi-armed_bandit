
clear all
%close all
clc

numtrials=100000;
mu1 = 6;
mu2 = 17;
mu3 = 14;
sigma1 = 19;
sigma2 = 11;
sigma3 = 2;

% random channel gain and corresponding data rate
%chan1 = sqrt(sigma1^2/2).*(randn(1,numtrials)+1i*randn(1,numtrials)) + mu1;
%chan2 = sqrt(sigma2^2/2).*(randn(1,numtrials)+1i*randn(1,numtrials)) + mu2;
%chan3 = sqrt(sigma3^2/2).*(randn(1,numtrials)+1i*randn(1,numtrials)) + mu3;

chan1 = sqrt(sigma1^2/2).*(randn(1,numtrials)) + mu1;
chan2 = sqrt(sigma2^2/2).*(randn(1,numtrials)) + mu2;
chan3 = sqrt(sigma3^2/2).*(randn(1,numtrials)) + mu3;
noise1 = sqrt(sigma1^2/2).*(randn(1,numtrials));
noise2 = sqrt(sigma2^2/2).*(randn(1,numtrials));
noise3 = sqrt(sigma3^2/2).*(randn(1,numtrials));

%g1 = abs(chan1).^2; % treat channel gain directly as SINR (equivlaent to noise variance = 1, tx power = 1
%g2 = abs(chan2).^2;
%g3 = abs(chan3).^2;

g1 = abs(chan1).^2 + abs(noise1).^2;
g2 = abs(chan2).^2 + abs(noise2).^2;
g3 = abs(chan3).^2 + abs(noise3).^2;

rate1 = log(1+g1);
rate2 = log(1+g2);
rate3 = log(1+g3);

%rate1 = log2(1+g1);
%rate2 = log2(1+g2);
%rate3 = log2(1+g3);



% calculate empirical CDF and CCDF
[r1_cdf,x1] = cdfcalc(rate1);
r1_ccdf = 1-r1_cdf(1:end-1);
[r2_cdf,x2] = cdfcalc(rate2);
r2_ccdf = 1-r2_cdf(1:end-1);
[r3_cdf,x3] = cdfcalc(rate3);
r3_ccdf = 1-r3_cdf(1:end-1);

% save data
save threshold.mat

% plot and save figure
% figure(1);
% plot(x1,r1_cdf(1:end-1),'-r','LineWidth',2);
% hold on;
% grid on;
% plot(x2,r2_cdf(1:end-1),'-b','LineWidth',2);
% plot(x3,r3_cdf(1:end-1),'-k','LineWidth',2);

%figure(2);
figure;
plot(x1,r1_ccdf,'-r','LineWidth',2);
hold on;
grid on;
plot(x2,r2_ccdf,'-b','LineWidth',2);
plot(x3,r3_ccdf,'-k','LineWidth',2);
xlabel('Channel rate [bpcu]','FontSize',14);
ylabel('CCDF','FontSize',14);
lgd = legend('channel 1 ($\mu=6, \sigma=19$)', 'channel 2 ($\mu=17, \sigma=11$)', 'channel 3 ($\mu=14, \sigma=2$)','Interpreter','latex','Location','southwest');
lgd.FontSize = 14;
title('CCDF of Rayleigh fading channel rates','FontSize',14);
savefig('CCDF.fig')
