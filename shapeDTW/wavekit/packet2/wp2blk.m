function b = wp2blk(w, N, i, j, level)

% WP2BLK -- return one block from a wavelet packet structure 
%
% b = wp2blk(w, N, i, j, level)
%
% w      is the structure
% N      original data NxN
% i,j    coordinates of the upper left hand corner of the block
% level  the level from which to extract

% (C) 1997 Harri Ojanen

delta = N / 2^(level);
if isstruct(w)
	b = w.wp(i:i+delta-1, j:j+delta-1, level);
elseif ndims(w) == 3
	b = w(i:i+delta-1, j:j+delta-1, level);
else
	b = w(i:i+delta-1, j:j+delta-1);
end