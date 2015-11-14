function wnew = seqtonat(w)

% SEQTONAT -- wavelet packet coefficients from sequency to natural order
%
% wnew = nattoseq(w)
%
% w contains wavelet packet coefficients in the sequency order (i.e.,
% the frequency index of a block is the nominal number of zero crossings
% of the corresponding wavelet packets). wnew contains the same
% coefficients but in the natural order, i.e., for wps1.
%
% The same transformation is applied to all columns of w.
%
% See also NATTOSEQ.

% (C) 1997 Harri Ojanen

if iswp1(w)
    n = prodlog(length(w.wp));
    N = 2^n;
    wnew = struct('wp', seqtonataux(w.wp, n, N), ...
             'sel', seqtonataux(w.sel, n, N));
else
    n = prodlog(length(w));
    N = 2^n;
    wnew = seqtonataux(w, n, N);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function wnew = seqtonataux(w, n, N)

wnew = w;
for scale = 2:n
    for freq = 3 : 2^scale
        newfreq = gc(freq-1)+1;
        idx = sfptoidx(scale, freq, N);
        newidx = sfptoidx(scale, newfreq, N);
        wnew(newidx, :) = w(idx, :);
    end
end

