function y = gc(x)

% GC -- gray code
%
% y = gc(x) produces the gray codes of the entries in x
% x is a vector of nonnegative integers
%
% See also IGC.

% (C) 1997 Harri Ojanen

x = x(:);
m = max(x);
if m > 0
    bits = [zeros(length(x),1) int2bits(x, ceil(log2(m))+1)];
    y = bits2int(rem(bits(:,1:size(bits,2)-1) + bits(:,2:size(bits,2)), 2));
else
    y = zeros(size(x));
end
