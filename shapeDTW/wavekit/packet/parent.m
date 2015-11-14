function [ps, pf] = parent(s, f)

% PARENT -- returns the scale and frequency indices for the parent subspace
%
% [parentscale, parentfreq] = parent(scale, freq)
%
% An error is produced if scale == 0.
%
% See also CHILDREN.

% (C) 1997 Harri Ojanen

if s == 0
    error('scale 0 has no parents')
end

ps = s - 1;
pf = floor((f-1)/2) + 1;

