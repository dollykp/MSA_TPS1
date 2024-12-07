function[sinus_aleat]=sin_aleatoire(N, ampl, freq, Fe);
  mu0 = freq * 1/Fe;
  phase = rand()*2*pi;
  sinus_aleat = zeros(1, N);
  for j = 1:N;
    sinus_aleat(j) = ampl * sin(2*pi*mu0*j + phase);
  endfor;
end;
