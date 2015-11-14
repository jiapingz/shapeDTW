function sout = ifwt1stp(s, d, h, g)

% ifwt1stp -- one level of an inverse wavelet transform
%
% sout = ifwt1stp(s, d, h, g)
%
% Calculates one level of an inverse wavelet transform.
% .m-file version of ifwt1stp.c
% Used by ifwt1 and ifwt1ns.

% (C) 1997 Harri Ojanen

s = s(:);
d = d(:);

N = length(s);
M = length(h) / 2;
sout = zeros(2*N, 1);

mask = N;
makeposit = max(256, mask);

n = 0 : N-1;
tnp2 = 2*n+2;
tnp1 = 2*n+1;

for k = 0 : M-1
    index = rem (n-k+makeposit, mask) + 1;
    sout(tnp2) = sout(tnp2) + h(2*k+2) * s(index) + g(2*k+2) * d(index);
    sout(tnp1) = sout(tnp1) + h(2*k+1) * s(index) + g(2*k+1) * d(index);
end
