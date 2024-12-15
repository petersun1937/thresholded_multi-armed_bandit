function [Sl_new] = F_Median_Elim(mu)

Sl = 1:length(mu(:));

% Median elimination
m = median(mu,'omitnan');
Sl_new = Sl(mu < m)';

end