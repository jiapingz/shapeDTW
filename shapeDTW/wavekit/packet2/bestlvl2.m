function [w, level] = bestlvl2(w)

% BESTLVL2 -- selects the best (fixed) level
%
% [w, level] = bestlevl(w)
%
% w          wavelet packet coefficients
% level      the number of the selected level
%
% See also WPBASES, BESTBASE, FIXLEVEL, WAVBASIS.

% (C) 1997 Harri Ojanen

n = size(w.wp, 3);
costs = zeros(n,1);

for i = 1:n
    costs(i) = costfn(w.wp(:,:,i));
end

[mincost, level] = min(costs);
w.sel = uint8(zeros(size(w.wp)));
w.sel(:,:,level) = uint8(ones(size(w.wp,1),size(w.wp,2)));

