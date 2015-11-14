function l=nsmsaidx(arg1, arg2)

% NSMSAIDX -- computes the indices of a block in a nonstandard msa
%
% nsmsaidx(msa)
%
% Returns a n-by-2 matrix of starting and ending indices of all the
% detail and smooth blocks in msa. These are arranged in the order
% d0, s0, d1, s1, d2 etc.
%
% With no output arguments, also prints the indices.
%
%
% l = nsmsaidx(level,smooth)
%
% Returns the starting and ending indices of a block at given level.
%
% level:   k for level 2^(-k)
%
% smooth:  0 or 'd'   for "detail" block
%          1 or 's'   for "smooth" block
%
% See also LASTLVL, LASTNSLV, MSALVL, NSMSALVL, MSAIDX.

% (C) 1997 Harri Ojanen

if nargin<2,
    k = lastnslv(arg1);
    l=[];
    for i=0:k,
        l = [l; 2^(i+1)-1, 2^(i+1)-2+2^i; 2^(i+1)-1+2^i, 2^(i+1)-2+2*2^i];
	if nargout==0,
            fprintf('d%d: %d .. %d\n', i, 2^(i+1)-1, 2^(i+1)-2+2^i);
            fprintf('s%d: %d .. %d\n', i, 2^(i+1)-1+2^i, 2^(i+1)-2+2*2^i);
	end
    end
else
    if arg2 == 1 | arg2 == 's',
        l = [2^(arg1+1)-1+2^arg1, 2^(arg1+1)-2+2*2^arg1];
    else
        l = [2^(arg1+1)-1, 2^(arg1+1)-2+2^arg1];
    end
end


