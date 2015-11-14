function y = nsmsalvl(data,level,smooth)

% NSMSALVL -- extract one multiscale level (nonstandard version)
%
% nsmsalvl(data, level, smooth)
%
% Data is from fwt1ns, level is an integer, smooth is 0 or 1.
%
% level:   k	level 2^(-k)
%
% smooth: 0 or 'd'   return "detail" coefficients
%         1 or 's'   return "smooth" coefficients
%
% See also LASTLVL, LASTNSLV, MSALVL, MSAIDX, NSMSAIDX.

% (C) 1993-1997 Harri Ojanen

if smooth == 1 | smooth == 's',
	y = data(2^(level+1)-1+2^level : 2^(level+1)-2+2*2^level);
else
	y = data(2^(level+1)-1 : 2^(level+1)-2+2^level);
end

y = y(:);
