function result = ifwt1ns(nsmsa, h, g)

% IFWT1NS -- inverse fast wavelet transform, non-standard version
%
% result = ifwt1ns(nsmsa, h, g)
%
% h and g are the scaling function and wavelet coefficients,
% nsmsa is the result of multiplying an operator with output from fwt1ns.
% 
% result is the inverse transform.
%
% Note: ifwt2ns(fwt1ns) is NOT identity!
%
% See also FWT1NS, IFWT1, FWT2, IFWT2.

% (C) 1993-1997 Harri Ojanen

snew = 0;

for j = 0:lastnslv(nsmsa),
  s = nsmsalvl(nsmsa, j, 1) + snew;
  d = nsmsalvl(nsmsa, j, 0);
  snew = ifwt1stp(s, d, h, g);
end

result = snew;
