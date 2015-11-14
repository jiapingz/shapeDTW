function w = fixlevel(w, level)

% FIXLEVEL -- selects a fixed level
%
% wout = fixlevel(w, level)
%
% See also BESTBASE, BESTLEVL, WAVBASIS.

% (C) 1997 Harri Ojanen

n = prodlog(length(w.wp));
selection = zeros(size(w.wp));
idx = sfptoidx(level, 1, 1, 2^n);
idx = idx : idx + 2^n - 1;
selection(idx) = ones(size(idx));
w.sel = uint8(selection);
