function y = isnsmsa(msa)

% ISNSMSA -- returns 1 if the argument is a nonstandard msa
%
% y = isnsmsa(msa)
%
% See also ISTNSMSA, FWT1, FWT1NS.

% (C) 1997 Harri Ojanen

b = log(length(msa)+2) / log(2);
y = b - round(b) < 1e-10;
