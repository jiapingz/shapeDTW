function wnew = nattoseq(w)

% NATTOSEQ -- wavelet packet coefficients from natural to sequency order
%
% wnew = nattoseq(w)
%
% w contains wavelet packet coefficients in the natural order, e.g.,
% computed with wpa1. wnew contains the same coefficients but in
% sequency order, i.e., the frequency index of a block is equal to
% the number of zero crossings the corresponding Haar-Walsh wavelets
% have.
%
% The same transformation is applied to all columns of w.
%
% See also SEQTONAT.

% (C) 1997 Harri Ojanen

if iswp1(w)
    n = prodlog(length(w.wp));
    N = 2^n;
    wnew = struct('wp', nattoseqaux(w.wp, n, N), ...
             'sel', nattoseqaux(w.sel, n, N));
else
    n = prodlog(length(w));
    N = 2^n;
    wnew = nattoseqaux(w, n, N);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function wnew = nattoseqaux(w, n, N)

wnew = w;
for scale = 2:n
    for freq = 3 : 2^scale
        newfreq = igc(freq-1)+1;
        idx = sfptoidx(scale, freq, N);
        newidx = sfptoidx(scale, newfreq, N);
        wnew(newidx, :) = w(idx, :);
    end
end

