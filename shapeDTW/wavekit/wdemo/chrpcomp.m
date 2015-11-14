function chrpcomp

% CHRPCOMP -- comparison of different ways to analyze two chirps
% 
% This demo explores different ways to analyze chirps, signals of the
% form  sin(f(t) t),  where the frequency  f(t)  depends on  t.
% 
% The first chirp is a linear chirp of the form sin(a t^2), where the 
% constant  a  is large enough for aliasing to show up in the phase
% plane plots.
%
% The second one is a linear combination of a linear and a cubic chirp.
% The formula is roughly  1/3 sin(3t^2) + sin(t^4).  Note how the
% difference in amplitudes is evident in the phase plane plots (through
% the different gray levels).
% 
% Obviously wavelet packets can clearly discriminate between the two
% signals, the other methods are not that successful.
% 
% See also WMENU, CHRPDEMO, WPSIG.

% (C) 1997 Harri Ojanen

t = 0 : 1/511 : 1;
[h,g] = wavecoef('coi', 24);



y1 = sin(pi*t.*(150*t.^3));   % cubic

y2 = sin(pi*t.*(500*t)) / 3;      % linear
y2 = y2 + sin(pi*t.*(150*t.^3));   % cubic


chrpcomf
fixpos

subplot(241); title('Single chirp');
subplot(242); title('Fourier transform');
subplot(243); title('Wavelet basis');
subplot(244); title('Best wavelet packet basis');
subplot(245); title('Superposed chirps');
subplot(246); title('Fourier transform');
subplot(247); title('Wavelet basis');
subplot(248); title('Best wavelet packet basis');
drawnow

watchon;

subplot(241); 
plot(t,y1);
axis square
title('Single chirp'), xlabel('time')
drawnow

subplot(242); 
plot(t-0.5,real(fftshift(fft(y1)))); 
axis square
title('Fourier transform'), xlabel('frequency')
drawnow

subplot(245); 
plot(t,y2); 
axis square
title('Superposed chirps'), xlabel('time')
drawnow

subplot(246); 
plot(t-0.5,real(fftshift(fft(y2)))); 
axis square
title('Fourier transform'), xlabel('frequency')
drawnow

subplot(243);
w1 = wpa1(y1,h,g);
phasepln(wavbasis(w1),h,g)
title('Wavelet basis'), xlabel('time'), ylabel('frequency')
drawnow

subplot(247);
w2 = wpa1(y2,h,g);
phasepln(wavbasis(w2),h,g)
title('Wavelet basis'), xlabel('time'), ylabel('frequency')
drawnow

subplot(244);
phasepln(bestbase(w1),h,g)
title('Best wavelet packet basis'), xlabel('time'), ylabel('frequency')
drawnow

subplot(248);
phasepln(bestbase(w2),h,g)
title('Best wavelet packet basis'), xlabel('time'), ylabel('frequency')
drawnow

watchoff;

set(gcf, 'handlevisibility', 'callback')
