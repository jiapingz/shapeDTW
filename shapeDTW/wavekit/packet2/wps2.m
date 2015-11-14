function y = wps2(w,h,g);

% WPS2 -- two dimensional wavelet packet synthesis
%
% y = wps2(w,h,g)
%
% w     wavelet packet coefficient structure from wpa1
% h,g   scaling function and wavelet filter coefficients
% y     inverse transform

% (C) 1997 Harri Ojanen

N = size(w.wp,1);
y = zeros(N,N);
w.wp = w.wp .* double(w.sel);
levels = log2(N);

%dots('wps2', levels);

for level = levels : -1 : 1
    blks = wp2blks(N, level);
    for i = blks
        for j = blks
            [hh,hg,gh,gg] = wp2chl(N, level, i, j, 1);
            s = w.wp(hh(1):hh(2), hh(3):hh(4), level);
            c = w.wp(gh(1):gh(2), gh(3):gh(4), level);
            b = w.wp(hg(1):hg(2), hg(3):hg(4), level);
            a = w.wp(gg(1):gg(2), gg(3):gg(4), level);

            y = ifwt2stp(a,b,c,s,h,g);

            if level > 1
                delta = N / 2^(level-1);	
                w.wp(i:i+delta-1, j:j+delta-1, level-1) = ...
                    w.wp(i:i+delta-1, j:j+delta-1, level-1) + y;
            end
        end
    end
    %dots;
end

%dots(-1);
