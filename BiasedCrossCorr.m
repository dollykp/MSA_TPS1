function [Cx,p] = BiasedCrossCorr(X,pmax)
  N = length(X);
  Cx = zeros(1, pmax+1);
  p = 0:pmax;
  for k = 0:pmax
    Cx(k+1) = sum(X(1:N-k) .* conj(X(1+k:N))) / N;
  endfor
end;
