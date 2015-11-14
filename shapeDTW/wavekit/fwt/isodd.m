function y = isodd(x)

% isodd -- returns 1 if the argument is an odd integer
%
% y = isodd(x)
%
% Works also when vectorized: y will have the same size as x.
%
% See also ISEVEN.

% (C) 1998 Harri Ojanen

y = bitget(x, 1);
