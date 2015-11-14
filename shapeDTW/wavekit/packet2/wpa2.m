function w = wpa2(y,h,g);

% WPA2 -- two dimensional wavelet packet analysis
%
% w = wpa2(y,h,g);
%
% Input arguments:
%     y    matrix to analyze (must be square, 2^n by 2^n)
%     h,g  low and high pass filters
%
% Output:
%     w    wavelet packet coefficients (matlab structure, see
%          the printed documentation for more details).
%
% See also WPS2.

% (C) 1997 Harri Ojanen

N = size(y,1);
w = struct('wp', zeros(N,N,log2(N)), 'sel', uint8(zeros(N,N,log2(N))));

levels = log2(N);
%dots('wpa2', levels)

for level = 1:levels
    blks = wp2blks(N, level);
    for i = blks
        for j = blks
            if level == 1
                [a,b,c,s] = fwt2step(y,h,g);
            else
                [a,b,c,s] = fwt2step(wp2blk(w, N, i, j, level-1), h, g);
            end
            [hh,hg,gh,gg] = wp2chl(N, level, i, j, 1);
            w.wp(hh(1):hh(2), hh(3):hh(4), level) = s;
            w.wp(gh(1):gh(2), gh(3):gh(4), level) = c;
            w.wp(hg(1):hg(2), hg(3):hg(4), level) = b;
            w.wp(gg(1):gg(2), gg(3):gg(4), level) = a;
        end
    end
    %dots;
end

%dots(-1);

                 
