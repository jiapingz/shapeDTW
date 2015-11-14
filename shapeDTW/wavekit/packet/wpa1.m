function w = wpa1(y,h,g)

% WPA1 -- one dimensional wavelet packet analysis
%
% w = wpa1(y,h,g)
%
% y    vector to transform (length 2^n)
% h,g  filter coefficients
% w    wavelet packet coefficients in natural order (length n*2^n)
% 
% See also WPS1.

% (C) 1997 Harri Ojanen

n = length(y);   % note that this is different from the help texts
w = zeros(n, log2(n)+1);
w(:,1) = y(:);
blocklength = n;

for level = 1:log2(n)
    blocklength = blocklength/2;
    for block = 1 : 2*blocklength : (n-2*blocklength+1)
        [s,d] = fwt1step(w(block : block + 2*blocklength-1, level), h, g);
        w(block : block+blocklength-1, level+1) = s;
        w(block+blocklength : block+2*blocklength-1, level+1) = d;
    end
end

w = w(:, 2:size(w,2));  % leave out y
w = w(:);

w = struct('wp', w, 'sel', uint8(zeros(size(w))));
