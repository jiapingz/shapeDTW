function y = wps1(w, h, g)

% WPS1 -- one dimensional wavelet packet synthesis
%
% y = wps1(w, h, g)
%
% w    wavelet packet coefficients in natural order (length n*2^n)
% h,g  filter coefficients
% y    synthesis (inverse transfrom of w) (length 2^n)
% 
% See also WPA1

% (C) 1997 Harri Ojanen

w = w.wp .* double(w.sel);

n = prodlog(length(w),1);
W = zeros(2^n,n);
W(:) = w(:);
W = [zeros(2^n,1) W];

for level = n:-1:1
    blocklength = 2^(n-level);
    for block = 1 : 2*blocklength : (2^n-2*blocklength+1)
        s = W(block : block+blocklength-1, level+1);
        d = W(block+blocklength : block+2*blocklength-1, level+1);
        sout = ifwt1stp(s,d,h,g);
        W(block : block+2*blocklength-1, level) = ...
            W(block : block+2*blocklength-1, level) + sout;
    end
end

y = W(:,1);
