function w = wavbasis(w)

% WAVBASIS -- selects the wavelet basis
%
% wout = wavbasis(w)
%
% See also BESTBASE, BESTLEVL, FIXLEVEL.

% (C) 1997 Harri Ojanen

n = prodlog(length(w.wp));
selection = zeros(size(w.wp));

for scale = 1:n
    idx = sfptoidx(scale, 2, 2^n);
    selection(idx) = ones(size(idx));
end

idx = sfptoidx(n, 1, 2^n);
selection(idx) = ones(size(idx));
w.sel = uint8(selection);
