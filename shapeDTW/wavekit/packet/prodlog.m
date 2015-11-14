function n = prodlog(m,isint)

% PRODLOG -- solves the equation n*2^n = m for integer n
%
% n = prodlog(m,isint)
%
% n and m as in the equation
%
% if the optional argument isint is nonzero, this routine will
% cause an error in case the solution(!) is not an integer.

% (C) 1997 Harri Ojanen

if nargin < 2, isint = 0; end

global PRODLOGM
PRODLOGM = log(m)/log(2);
n = fzero('prodloga', PRODLOGM);
clear PRODLOGM

if isint & abs(n-round(n)) > 1e-10
    error('prodlog: input argument m is not of the form n*2^n for integer n');
end
n = round(n);
