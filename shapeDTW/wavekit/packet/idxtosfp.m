function [s, f, p] = idxtosfp(i,N)

% IDXTOSFP -- transforms array indices to corresponding (s,f,p) triples
%
% [scale, freq, pos] = idxtosfp(i, N)
%
% The parameters are as in sfptoidx
%
% See also SFPTOIDX.

% (C) 1997 Harri Ojanen

%if i == 1
%    s = 1;
%    f = 1;
%    p = 1;
%else    
    s = floor((i-1) ./ N) + 1;
    f = floor((i-1 - (s-1) .* N) .* 2.^s ./ N) + 1;
    p = i - (s-1) .* N - (f-1) .* N .* 2.^(-s);
%end    
