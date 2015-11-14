function A = fwt2(s, h, g)

% FWT2 -- two dimensional fast wavelet transform
%
% A = fwt2(s, h, g)
%
% Input:
%   s     original matrix 
%   h,g   filter coefficients for the scaling function and wavelet
% 
% Output:
%   A     resulting two dimensional multi-scale analysis
%
% See also IFWT2, FWT1, FWT1NS, FWT2TNS, FWT2NS.

% (C) 1993-1997 Harri Ojanen

[n,m] = size(s);
A = zeros(n,n);

if length(s) == 1, news = s; end

while (length(s) >= 2),
    [alpha, beta, gamma, news] = fwt2step(s, h, g);
    newA = [zeros(length(gamma)) beta; gamma alpha];
    n = length(newA);
    A(1:n, 1:n)=newA;
    s = news;
end
    
A(1,1) = news;
