function [ls, lf, rs, rf] = children(s, f)

% CHILDREN -- scale and frequency indices of the two children of a subspace
%
% [leftscale, leftfreq, rightscale, rightfreq] = children(scale, freq)
%
% The arguments should be self explanatory.
%
% See also PARENT.

% (C) 1997 Harri Ojanen

ls = s + 1;
rs = s + 1;
lf = 2*f - 1;
rf = 2*f;


