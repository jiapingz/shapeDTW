function w = waveletd(f, x, g)

% waveletd -- construct a wavelet from the solution to a dilation equation
%
% w = waveletd(f, x, g)
%
% f, x   are the solution as returned by  dilation
% g      wavelet filter coefficients
% w      the values of the wavelet on the grid  x
%
% See also WAVDEMO, DILATION.

% (C) 1993-1997 Harri Ojanen

f = f(:);
x = x(:);
w = zeros(size(x));
h = x(2)-x(1);
g = sqrt(2)*g(:);   % to preserve L2 norm of *functions*

for k = 1 : length(g)
    i = 1 : length(w);
    j = round(2*i - (k-1)/h + 1);
    l = find(j >= 0 & j <= length(w));
    w(i(l)) = w(i(l)) + g(k)*f(j(l));
end
