% xwplchrp -- chirps that came with xwpl

[h,g] = wavecoef('coi', 24);

figure(1);clf;subplot(121);
load /fermat/u1/ojanen/xwpl/data/linchirp.asc
wl = wpa1(linchirp, h, g);
sl = bestbase(wl);
phasepln(wl, sl, h, g); title('Linear chirp')

subplot(122)
load /fermat/u1/ojanen/xwpl/data/quadchrp.asc
wq = wpa1(quadchrp, h, g);
sq = bestbase(wq);
phasepln(wq, sq, h, g); title('Quadratic chirp')
print -dps k.ps

figure(2);clf;subplot(121);
load /fermat/u1/ojanen/xwpl/data/twochrp1.asc
w1 = wpa1(twochrp1, h, g);
s1 = bestbase(w1);
phasepln(w1, s1, h, g); title('Two superposed chirps')

subplot(122);
load /fermat/u1/ojanen/xwpl/data/twochrp2.asc
w2 = wpa1(twochrp2, h, g);
s2 = bestbase(w2);
phasepln(w2, s2, h, g); title('Two superposed chirps')
print -dps -append k.ps


