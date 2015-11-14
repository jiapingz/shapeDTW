function A = fwt2ns(s, h, g, packed, lastlevel)

% FWT2NS -- fast wavelet transform, two dimensional, non-standard form
%
% A = fwt2ns(s, h, g, packed, lastlevel)
%
% Input:
%   s     original matrix 
%   h,g   scaling function and wavelet filter coefficients
% 
% Output:
%   A     resulting two dimensional multi-scale analysis
%
% Options:
%   packed  if packed==1, A is given in packed form, otherwise in larger
%           ns-form
%           (default: ns-form).
%   lastlevel
%           last level to compute, value is the size of sub-matrices
%           at this level (default: all levels). This is used only 
%           if packed==1.
%
% See also FWT2, FWT1NS, IFWT1NS, FWT2TNS, IFWT2.

% (C) 1993-1997 Harri Ojanen

if nargin < 4, packed = 0; end

if packed,
    if nargin < 5,
        lastlevel = 1;
    end
    [n,m] = size(s);
    A = zeros(n,n);

    while (length(s) >= lastlevel*2),
        [alpha, beta, gamma, news] = fwt2step(s, h, g);
        newA = [zeros(length(gamma)) beta; gamma alpha];
        n = length(newA);
        A(1:n, 1:n)=newA;
        s = news;
    end
    
    n = length(news);
    A(1:n,1:n) = news;

else
    [n,m] = size(s);
    A = zeros(2*n-2,2*n-2);

    while (length(s) >= 2),
        [alpha, beta, gamma, news] = fwt2step(s, h, g);
        newA = [alpha beta; gamma zeros(length(gamma))];
        n = length(newA);
        A(n-1:2*n-2,n-1:2*n-2)=newA;
        s = news;
    end
    A(2,2) = s;
end

%fprintf('\r                                                            \r');
