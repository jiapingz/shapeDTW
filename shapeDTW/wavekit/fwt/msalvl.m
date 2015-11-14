function y = msalvl(data,level)

% MSALVL -- extract one multiscale level
%
% msalvl(data, level)
%
% Data is from fwt, level is an integer
%
% level: -1 	scaling function
%	  k	level 2^(-k)
%
% See also LASTLVL, LASTNSLV, NSMSALVL, MSAIDX, NSMSAIDX.

% (C) 1993-1997 Harri Ojanen

if level == -1,
	y = data(1);
else
	y = data(2^level+1 : 2^(level+1));
end
