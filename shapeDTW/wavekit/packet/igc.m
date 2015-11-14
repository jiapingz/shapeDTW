function y = igc(x)

% IGC -- inverse gray code
%
% y = igc(x) produces the inverse gray codes of the entries in x
% x is a vector of nonnegative integers
%
% See also GC.

% (C) 1997 Harri Ojanen

x = x(:);
m = max(x);
if m > 0
    bits = int2bits(x, ceil(log2(m)+1));
    y = bits2int(rem(cumsum(bits')', 2));
else
    y = zeros(size(x));
end
