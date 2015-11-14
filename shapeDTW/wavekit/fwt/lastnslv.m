function k = lastnslv(nsmsa)

% LASTNSLV -- index of the last level in a nonstandard msa
%
% k = lastnslv(nsmsa)
%
% Returns the index (or level number) of the last multiscale
% analysis level in nsmsa. 
%
% See also LASTLV, MSALVL, NSMSALVL, MSAIDX, NSMSAIDX.

% (C) 1993-1997 Harri Ojanen

k = log(length(nsmsa)+2)/log(2)-2;

if (abs(round(k)-k)>10*eps),
	error('Length of nsmsa must be 2^n-2.');
end

k = round(k);
