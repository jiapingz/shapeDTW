function [A,B,C] = comscale(a,b,c)

% COMSCALE -- scales three matrices to have entries between 0 and 1
%
% [A,B,C] = comscale(a,b,c)
% 
% Scales the three matrices to have entries in [0,1] (applies the same
% scaling to each one of them).
%
% A = comscale(a)
%
% Scales one matrix.

% (C) 1997 Harri Ojanen

if nargin == 3,
    mi = min([min(min(a)) min(min(b)) min(min(c))]);
    A = a-mi;
    B = b-mi;
    C = c-mi;
    ma = max([max(max(A)) max(max(B)) max(max(C))]);
    if (ma > 0), 
	A = A / ma;
	B = B / ma;
	C = C / ma;
    end
else
    mi = min(min(a));
    A = a-mi;
    ma = max(max(A));
    if (ma > 0), 
	A = A / ma;
    end
end
