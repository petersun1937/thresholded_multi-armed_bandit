function [ucb] = KLBinSearch_2lv(f,mu1,mu2)

K = length(mu1);


% Initialize upper bounds and lower bounds
lb1 = mu1; ub1 = min(1,mu1+sqrt(f/2));
lb2 = mu2; ub2 = min(1,mu2+sqrt(f/2));
%lb = zeros(size(mu)); ub = ones(size(mu));

for j = 1:32          %2^(K)?
    % Pick p as the middle value of upperbounds and lowerbounds
    p = (ub1+lb1)/2;
    q = (ub2+lb2)/2;
    
    y1 = KLDiv(mu1,p);
    y2 = KLDiv(mu2,q);
    
    % Check which elements(arms) in y is greater than d
    % If yes, update the corresponding values in p
    % as upperbounds and the rest as lowerbounds
    down = y1+y2 > f;  

    ub1(down) = p(down);
    lb1(~down) = p(~down);
    
    ub2(down) = q(down);
    lb2(~down) = q(~down);
end
ucb = ub1.*ub2;

end