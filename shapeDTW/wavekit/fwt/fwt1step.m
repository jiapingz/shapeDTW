function [sout, dout] = fwt1step (s, h, g)

% fwt1step -- one level of a wavelet transform
%
% [sout, dout] = fwt1step (s, h, g)
%
% Calculates one level of a wavelet transform.
% .m-file version of fwt1step.c
% Used by fwt1 and fwt1ns.

% (C) 1997 Harri Ojanen

s = s(:);

mask = length(s);
N = mask / 2;
M = length(h);

sout = zeros(N, 1);
dout = zeros(N, 1);
k = 0 : N - 1;

for n = 0 : M - 1
    index = rem (n + 2*k, mask) + 1;
    sout = sout + h(n+1) * s(index);
    dout = dout + g(n+1) * s(index);
end
