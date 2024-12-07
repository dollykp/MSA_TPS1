clear all;
close all;
clc;

pkg load communications;

## à utiliser pour tracer les figures-------------------------------------------

##figure();
##subplot();
##plot();
##xlabel("");
##ylabel("");
##title("");
##grid on;
##set(findall(gcf,'-property','FontSize'),'FontSize',50);

##------------------------------------------------------------------------------

N = 256;
variance = 1;
pmax = 255;
sigma_2 =1;
Fe = 10^4;

%checkpoint 1
bruit_blanc = BB(N, variance);
[Cx1, p1] = BiasedCrossCorr(bruit_blanc, pmax);

##figure(1);
##subplot(211);
##plot(bruit_blanc, "b");
##xlabel("Échantillons");
##ylabel("Amplitude");
##title("Bruit blanc");
##grid on;
##
##subplot(212);
##stem(p1, Cx1, "b");
##xlabel("Décalage p");
##ylabel("Cx(p)");
##title("Estimateur biaisé d'autocorrélation du bruit blanc");
##grid on;
##set(findall(gcf,'-property','FontSize'),'FontSize',50);

%checkpoint 2
a = [1, -0.7];
b = 1;
processus_AR = AR(a, b, sigma_2, N);

[Cx2, p2 ] = BiasedCrossCorr(processus_AR, pmax);

##figure(2);
##subplot(211);
##plot(processus_AR, "r");
##xlabel("Échantillons");
##ylabel("Amplitude");
##title("Processus AR(1)");
##grid on;
##
##subplot(212);
##stem(p2, Cx2, "r");
##xlabel("Décalage p");
##ylabel("Cx(p)");
##title("Estimateur biaisé d'autocorrélation du processus AR(1)");
##grid on;
##set(findall(gcf,'-property','FontSize'),'FontSize',50);

%checkpoint 3
ampl =5;
freq =100;
sinus_aleat = sin_aleatoire(N, ampl, freq, Fe);

[Cx3, p3] = BiasedCrossCorr(sinus_aleat, pmax);

##figure(3);
##subplot(211);
##plot(sinus_aleat, "b");
##xlabel("Échantillons");
##ylabel("Amplitude");
##title("Sinus à phase aléatoire");
##grid on;
##
##subplot(212);
##stem(p3, Cx3, "b");
##xlabel("Décalage p");
##ylabel("Cx(p)");
##title("Estimateur biaisé d'autocorrélation du sinus à phase aléatoire");
##grid on;
##set(findall(gcf,'-property','FontSize'),'FontSize',50);

##------------------------------------------------------------------------------

%checkpoint 4
[Cx4, p4] = UnbiasedCrossCorr(bruit_blanc, pmax);
[Cx5, p5] = UnbiasedCrossCorr(processus_AR, pmax);
[Cx6, p6] = UnbiasedCrossCorr(sinus_aleat, pmax);

##figure(4);
##subplot(311);
##stem(p1, Cx1, "b", "DisplayName", "Estimateur biaisé");
##hold on;
##stem(p4, Cx4, "r", "DisplayName", "Estimateur non biaisé");
##xlabel("Décalage p");
##ylabel("Cx(p)");
##title("Bruit blanc");
##grid on;
##legend("location", "eastoutside");
##
##subplot(312);
##stem(p2, Cx2, "b");
##hold on;
##stem(p5, Cx5, "r");
##xlabel("Décalage p");
##ylabel("Cx(p)");
##title("Processus AR(1)");
##grid on;
##
##subplot(313);
##stem(p3, Cx3, "b");
##hold on;
##stem(p6, Cx6, "r");
##xlabel("Décalage p");
##ylabel("Cx(p)");
##title("Sinus à phase aléatoire");
##grid on;
##
##set(findall(gcf,'-property','FontSize'),'FontSize',50);

%-----------------------

[audio1, fe1] = audioread('C:/TP_MSA_S7/voise_oo.flac');
[audio2, fe2] = audioread('C:/TP_MSA_S7/voise_ooo.flac');

audio1 = audio1';
audio2 = audio2';

tps1 = [1:size(audio1,2)]/fe1;
tps2 = [1:size(audio2,2)]/fe2;

##figure(5);
##subplot(211);
##plot(tps1, audio1, "b");
##xlabel("Temps (en s)");
##ylabel("Amplitude");
##title("Son voisé oo");
##grid on;
##
##subplot(212);
##plot(tps2, audio2, "b");
##xlabel("Temps (en s)");
##ylabel("Amplitude");
##title("Son voisé ooo");
##grid on;
##set(findall(gcf,'-property','FontSize'),'FontSize',50);

% autocorrélation de sons voisés
[Cx7, p7] = UnbiasedCrossCorr(audio1, 1024);
abs1 = 1:fe1/1024:fe1;

[Cx8, p8] = UnbiasedCrossCorr(audio2, 1024);
abs2 = 1:fe2/1024:fe2;

##figure(6);
##stem(abs1, abs(fft(Cx7, 1024)), "r");
##xlabel("Fréquences (en Hz)");
##ylabel("Audio (en V.Hz)");
##title("FFT du son voisé oo");
##grid on;
##set(findall(gcf,'-property','FontSize'),'FontSize',50);
##
##figure(7);
##stem(abs2, abs(fft(Cx8, 1024)), "r");
##xlabel("Fréquences (en Hz)");
##ylabel("Audio (en V.Hz)");
##title("FFT du son voisé ooo");
##grid on;
##set(findall(gcf,'-property','FontSize'),'FontSize',50);

%sons non voisés

[audio3, fe3] = audioread('C:/TP_MSA_S7/nonvoise_ch.flac');
[audio4, fe4] = audioread('C:/TP_MSA_S7/nonvoise_kss.flac');

audio3 = audio3';
audio4 = audio4';

tps3 = [1:size(audio3,2)]/fe3;
tps4 = [1:size(audio2,2)]/fe4;

[Cx9, p9] = BiasedCrossCorr(audio3, 1024);
abs3 = 1:fe3/1024:fe3;

[Cx10, p10] = BiasedCrossCorr(audio4, 1024);
abs4 = 1:fe4/1024:fe4;

figure(8);
subplot(311);
plot(tps3, audio3, "r");
xlabel("Temps (en s)");
ylabel("Amplitude");
title("Son non voisé 'ch'");
grid on;

subplot(312);
plot(p9, Cx9, "r");
xlabel("Décalage p");
ylabel("Autocorrélation");
title("Estimateur biaisé du son non voisé 'ch'");
grid on;

subplot(313);
plot(abs3, abs(fft(Cx9, 1024)), "r");
xlabel("Fréquences (en Hz)");
ylabel("FFT");
title("FFT de l'autocorrélation du son non voisé 'ch'");
grid on;

set(findall(gcf,'-property','FontSize'),'FontSize',50);

##figure(9);
##subplot(212);
##plot(p10, Cx10, "r");
##xlabel("Décalage p");
##ylabel("Autocorrélation");
##title("Estimateur biaisé du son non voisé 'kss'");
##grid on;
##set(findall(gcf,'-property','FontSize'),'FontSize',50);

