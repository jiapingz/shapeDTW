function [w, level] = bestlevl(w)

% BESTLEVL -- selects the best (fixed) level
%
% [wout, level] = bestlevl(w)
%
% w       wavelet packet coefficients
% wout    describes the selected coefficients
% level   the number of the selected level
%
% See also BESTBASE, FIXLEVEL, WAVBASIS.

% (C) 1997 Harri Ojanen

n = prodlog(length(w.wp));
costs = zeros(n,1);

for i = 1:n
    v = fixlevel(w,i);
    costs(i) = costfn(w.wp(find(v.sel)));
end

[mincost, level] = min(costs);
w = fixlevel(w,level);
	
