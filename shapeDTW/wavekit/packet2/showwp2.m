function showwp2(w,varargin)

% SHOWWP2 -- displays the selected wavelet packet basis graphically
% 
% showwp2(w)
%
% Uses  showoper  to graph the selected coefficients and then 
% wp2grid  to draw the grid that describes the basis (i.e., how
% the matrix is partitioned).
% 
% See also SHOWOPER.

% (C) 1997 Harri Ojanen

showoper(sum(w.wp .* double(w.sel), 3), varargin{:});
wp2grid(w);
