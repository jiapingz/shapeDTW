function A = ifwt2(w, h, g)

% IFWT2 -- two dimensional inverse wavelet transform
%
% A = ifwt2ns(w, h, g)
%
% Input:
%   w     two dimensional wavelet coefficients
%   h,g   filter coefficients for the scaling function and wavelet
% 
% Output:
%   A     inverse transform of w
%
% See also FWT2, IFWT2TNS, FWT2TNS, IFWT1, IFWT1NS.

% (C) 1997 Harri Ojanen

[n,m] = size(w);
A = w(1,1);

i = 1;
while i < n
    alpha = w(i+1:2*i, i+1:2*i);
    beta =  w(1:i, i+1:2*i);
    gamma = w(i+1:2*i, 1:i);
    A = ifwt2stp(alpha, beta, gamma, A, h, g);
    i = 2*i;
end
