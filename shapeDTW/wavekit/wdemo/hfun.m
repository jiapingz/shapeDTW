function y = h(r)

% HFUN -- used by nsexampl
%
% See also NSEXAMPL.

% (C) 1997 Harri Ojanen

%y = (r<1) - (r<2 & r>=1) - (r<4 & r>=2) + (r>=4);

%y = sqrt(r) + sqrt(abs(r-1)) + sqrt(abs(r-2)) + sqrt(abs(r-4));

y = (cos(r.^2));
