function k = lastlvl(msa)

% LASTLVL -- index of the last level in a (standard) msa
%
% k = lastlvl(msa)
%
% Returns the index (or level number) of the last multiscale
% analysis level in msa (s0 level is index by -1, d0 by 0,
% d1 by 1 etc.). 
%
% See also LASTNSLV, MSALVL, NSMSALVL, MSAIDX, NSMSAIDX.

% (C) 1993-1997 Harri Ojanen

k = log(length(msa))/log(2);

if (abs(round(k)-k)>10*eps),
	error('Length of msa must be 2^n.');
end

k = round(k)-1;
