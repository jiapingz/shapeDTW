function s = ifwt1(msa, h, g)

% IFWT1 -- inverse fast wavelet transform, standard version
%
% result = ifwt1(msa, h, g)
%
% h  and  g  are the filter coefficients for the scaling function 
% and wavelet,  msa  is a standard multiscale analysis, e.g.,
% produced by fwt1.
% 
% result  is the inverse transform.
%
% fwt1  followed by  ifwt1  is the identity.
%
% See also FWT1, IFWT1NS, FWT2TNS, IFWT2TNS.

% (C) 1993-1997 Harri Ojanen

s = msa(1);
k = 1;

while k < length(msa)
  d = msa(k+1:2*k);
  s = ifwt1stp(s, d, h, g);
  k = k*2;
end


