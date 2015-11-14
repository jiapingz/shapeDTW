function y = bits2int(x)

% BITS2INT -- convert a row vector of bits into a single integer
%
% y = bits2int(x)
%
% Most significant bit is in x(1) or x(1,:).
%
% Works also if x is a column vector with the obvious meaning.
%
% See also INT2BITS.

% (C) 1997 Harri Ojanen

y = x(:,1);

for i=2:size(x,2)
    y = 2*y + x(:,i);
end


