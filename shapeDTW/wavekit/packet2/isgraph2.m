function f = isgraph2(w)

% ISGRAPH2 -- checks if a graph basis has been selected
%
% b = isgraph2(w)
%
% b  is 1 if a graph basis (or a subset of a graph basis) has been selected
% in the wavelet packet structure  w.

% (C) 1997 Harri Ojanen

a = sum(double(w.sel),3);
f = all(a(:) <= 1);
