function y = int2bits(x,n)

% INT2BITS -- converts an integer to its bit representation
%
% y = int2bits(x,n)
%
% x   column vector to transform
% n   word length (default: 8)
%
% y   length(x) by n matrix of zeros and ones (most significant bits
%     in the first column).
%
% See also BITS2INT.

% (C) 1997 Harri Ojanen

if nargin < 2,
    n = 8;
end

y = zeros(length(x),n);

for i = 1:n,
    a = floor(x/2);
    y(:,n-i+1) = x - 2*a;
    x = a;
end
