function [hh,hg,gh,gg] = wp2chl(N, level, ifreq, jfreq, isblocks)

% WP2CHL -- indices for the child blocks
%
% [hh,hg,gh,gg] = wp2chl(N, level, ifreq, jfreq)
% [hh,hg,gh,gg] = wp2chl(N, level, iblock, jblock, 1)
%
% First form uses frequency numbers, second form the actual indices
% of the parent block.
%
% Each one of the output vector is a four vector of the form
% [imin imax jmin jmax].

% (C) 1997 Harri Ojanen

if nargin < 5, isblocks = 0; end

delta = N / (2^(level-1));
if isblocks
	i = ifreq;
	j = jfreq;
else
	i = (ifreq-1) * delta + 1;
	j = (jfreq-1) * delta + 1;
end
%hh = [i         i+delta/2-1 j         j+delta/2-1];
%gh = [i         i+delta/2-1 j+delta/2 j+delta-1];
%hg = [i+delta/2 i+delta-1   j         j+delta/2-1];
%gg = [i+delta/2 i+delta-1   j+delta/2 j+delta-1];

hh = [i         i+delta/2-1 j         j+delta/2-1];
hg = [i         i+delta/2-1 j+delta/2 j+delta-1];
gh = [i+delta/2 i+delta-1   j         j+delta/2-1];
gg = [i+delta/2 i+delta-1   j+delta/2 j+delta-1];
