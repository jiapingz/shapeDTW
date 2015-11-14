function l = msaidx(arg1, arg2)

% MSAIDX -- computes the indices of a block in a (standard) msa
%
% msaidx(msa)
%
% Returns a n-by-2 matrix of starting and ending indices of all the
% detail and smooth blocks in msa. These are arranged in the order
% d0, s0, d1, s1, d2 etc.
%
% With no output arguments, also prints the indices.
%
%
% l = msaidx(level,'level')
%
% Returns the starting and ending indices of a block at given level.
% (the s0 level is index by level = -1)
%
% level:   k for level 2^(-k)
%
% See also LASTLVL, LASTNSLV, MSALVL, NSMSALVL, NSMSAIDX.

% (C) 1997 Harri Ojanen

if nargin<2,
    k = lastlvl(arg1);
    l= [1 1] ;
    fprintf('s%d: %d .. %d\n', 0, l(size(l,1),1), l(size(l,1),2)); 
    for i = 0:k,
        l = [l; 2^i+1, 2*2^i];
	if nargout==0,
            fprintf('d%d: %d .. %d\n', i, l(size(l,1),1), l(size(l,1),2)); 
	end
    end
else
    if arg1 == -1
        l = [1 1];
    else
        l = [2^(arg1)+1, 2*2^(arg1)];
    end
end


