function i = wp2blks(N, level)

% WP2BLKS -- indices for the upper left hand corner of all blocks
%
% i = wp2blks(N, level)
%
% Indices for the whole  [hh gh; hg hh]  blocks.
% 
% N       original data has size NxN 
% level   blocks for this level
% i       a row vector containing the x-coordinates (= y-coordinates)
%         of the upper left hand corner of all blocks at this level

% (C) 1997 Harri Ojanen

delta = N / (2 ^ (level-1));
i = 1 : delta : N - delta + 1;
