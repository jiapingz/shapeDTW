function imgdemo

% IMGDEMO -- very simple image demo
%
% This demo displays a photograph and three transforms of it:
%
%    a truncated wavelet packet transform
%    best basis wavelet packet transform
%    fixed level wavelet packet transform
% 
% See also WMENU.

% (C) 1997 Harri Ojanen

imgdemof;
fixpos
watchon;

load pict128

[h,g] = wavecoef('dau', 8); 

subplot(221); title('Original'); aa
subplot(222); title('Truncated wavelet transform'); aa
subplot(223); title('Best wavelet packet basis'); aa
subplot(224); title('Fixed level wavelet packets'); aa
drawnow

subplot(221)
imagesc(pict)
title('Original')
aa;

subplot(222)
w = varfwt2(pict, h, g, 32);
imagesc(w)
nsgrid(5)
title('Truncated wavelet transform')
aa;

subplot(223)
wp=wpa2(pict,h,g);
wp=bestbas2(wp);
showwp2(wp);
title('Best wavelet packet basis')
aa;

subplot(224)
wp=fixlvl2(wp,2);        
showwp2(wp);
title('Fixed level wavelet packets')
aa;

watchoff

set(gcf, 'handlevisibility', 'callback');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function aa
axis square
axis off
colormap(gray)
drawnow
