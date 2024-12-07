function [bruit_blanc] = BB(N, variance)
  bruit_blanc = sqrt(variance) * randn(1, N);
end;
