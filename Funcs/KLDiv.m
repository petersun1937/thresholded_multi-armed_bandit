function d = KLDiv(a,b)
  a = min(max(a, eps),1-eps); 
  b = min(max(b, eps),1-eps);
  
  % Check probabilities sum to 1:
  %  if (abs(sum(a) - 1) > .00001) || (abs(sum(b) - 1) > .00001),
  %      error('Probablities don''t sum to 1.')
  %  end
  
  d = a.*log(a./b) + (1-a).*log((1-a)./(1-b));
end