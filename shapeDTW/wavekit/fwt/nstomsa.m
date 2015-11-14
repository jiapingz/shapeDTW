function y = nstomsa(m)

% NSTOMSA -- converts a nonstandard msa to a standard one
%
% y = nstomsa(m)
%
% m    non standard msa (as produced by fwt1ns)
% y    standard msa
%
% See also FWT1, FWT1NS, SHOWMSA, SHOWNSMS.

% (C) 1993-1997 Harri Ojanen

m = m(:);
y = m(2);

for i=0:lastnslv(m),
    l = nsmsaidx(i,'d');
    y = [y; m(l(1):l(2))];
end
