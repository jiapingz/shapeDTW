function w = fwt1(s, h, g)

% FWT1 -- fast wavelet transform, one dimensional standard version
%
% w = fwt1(f,h,g)
%
% Input:
%     f     Vector to transform
%     h     Filter coefficients for the scaling function
%     g     Filter coefficients for the wavelet
%
% Output:
%     w     contains standard multiscale analysis (column vector)
%
% The wavelet coefficients are stored in the following order:
%
%     w = [sn | dn | d(n-1) | d(n-2) | ... | d2 | d1 ]
%
% where length(sn) = 1, length(di) = 2^(-i)*length(w) and 
% n = log2(length(w)).
%
% See also IFWT1, FWT1NS, FWT2, FWT2TNS.

% (C) 1993-1998 Harri Ojanen

w = zeros(length(s),1);

while (length(s) >= 4),
  [sout, dout] = fwt1step(s, h, g);
  n = length(dout);
  w(n+1:2*n) = dout;
  s = sout;
end

[sout, dout] = fwt1step(s, h, g);
w(1) = sout;
w(2) = dout;

