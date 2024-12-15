function ucb = KLBinSearch(d,mu)

K = length(mu);


% Initialize upper bounds and lower bounds
lb = mu; ub = min(1,mu+sqrt(d/2));
%lb = zeros(size(mu)); ub = ones(size(mu));

for j = 1:32          %2^(K)?
    % Pick p as the middle value of upperbounds and lowerbounds
    p = (ub+lb)/2;

    y = KLDiv(mu,p);

    % Check which elements(arms) in y is greater than d
    % If yes, update the corresponding values in p
    % as upperbounds and the rest as lowerbounds
    down = y > d;  

    ub(down) = p(down);
    lb(~down) = p(~down);
end
ucb = ub;

end