function y = isstdmsa(msa)

% ISSTDMSA -- returns 1 if the argument is a standard msa
%
% y = isstdmsa(msa)
%
% See also ISNSMSA, FWT1, FWT1NS.

% (C) 1997 Harri Ojanen

b = log(length(msa)) / log(2);
y = b - round(b) < 1e-10;
