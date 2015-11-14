function y = prodloga(n)

% prodloga -- auxiliary routine used by prodlog
%
% y = prodloga(n)
%
% used as the target function in fzero, see prodlog for details
%
% See also PRODLOG.

% (C) 1997 Harri Ojanen

global PRODLOGM
y = log(n)/log(2) + n - PRODLOGM;

