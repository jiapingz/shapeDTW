function [w, dropped, kept] = discard(w, threshold)

% DISCARD -- discards small coefficients from the selection
%
% [wout, dropped, kept] = discard(w, threshold)
%
% w            wavelet packet coefficients
% threshold    all entries with absolute value less than threshold times
%              the l2 norm of w are dropped
%
% newselection markes those coefficients that are kept
% dropped      number of coefficients that were dropped
% kept         number of coefficients that were kept

% (C) 1997 Harri Ojanen

newselection = zeros(size(w.sel));

i = find(w.sel);
keep = i(find(abs(w.wp(i)) >= threshold * norm(w.wp,2)));
newselection(keep) = ones(size(keep));

kept = length(keep);
dropped = length(i) - kept;

w = struct('wp', w.wp, 'sel', uint8(newselection));
