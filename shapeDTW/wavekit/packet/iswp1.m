function b = iswp1(w)

% ISWP1 -- true for one dimensional wavelet packet structures
%
% b = iswp1(w)

% (C) 1997 Harri Ojanen

b = isstruct(w) & isfield(w, 'wp') & isfield(w, 'sel');
