function w = fwt1ns(s, h, g)

% FWT1NS -- fast wavelet transform, one dimensional non-standard version
%
% w = fwt1ns(s,h,g)
%
% Input:
%	s	values of the function to transform
%	h	scaling function filter coefficients
%	g	wavelet filter coefficients
%
% Output:
%	w	contains non-standard multiscale analysis
%
% See also IFWT1NS, FWT1, FWT2, FWT2NS.

% (C) 1993-1997 Harri Ojanen

w = zeros(2*length(s)-2,1);

while (length(s) >= 2),
  [sout, dout] = fwt1step(s, h, g);
  new = [dout; sout];
  n = length(new);
  w(n-1:2*n-2,1) = new;
  s = sout;
end