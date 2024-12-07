function[processus_AR]=AR(a, b, sigma_2, N);
  bruit_blanc = BB(N, sqrt(sigma_2));
  processus_AR=filter(b, a, bruit_blanc);
end;
