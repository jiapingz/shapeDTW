function i = sfptoidx(s, f, p, N)

% SFPTOIDX -- converts (scale,frequence,position) triples to array indices
%
% i = sfptoidx(s, f, p, N)
% i = sfptoidx(s, f, N)
%
% s   scale
% f   frequency
% p   position (optional, if not given a list of all indices corresponding
%     to this subspace is returned)
% N   length of the original analyzed vector (2^n)
%
% See also IDXTOSFP.

% (C) 1997 Harri Ojanen

if nargin < 4
    N = p;
    i = (s-1) .* N + (f-1) .* 2.^(-s) .* N;
    i = (i+1) : (i+N.*2.^(-s));
else
    i = (s-1) .* N + (f-1) .* 2.^(-s) .* N + p;
end    

