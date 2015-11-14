function [f,x] = dilation(c,levels,f,silent)

% dilation -- solution to a dilation equation
%
% f = dilation(c,levels)
%
% Inputs:
%  c        Coefficients from the dilation equation (automatically 
%           normalized).
%  levels   How deep to iterate, result will be calculated on points
%           2^(-levels) apart.
%
% Output:
%   f       The solution.
%
% Note! This program first solves the exact values of f on
% integers. This means solving an eigenvalue problem, which sometimes
% fails. For discontinuous solutions, you must supply the initial data
% explicitely, see below.
%
% Optional arguments:
%   [f,x] = dilation(c,levels,initf)
%   initf   Iteration is started with this vector as initial data; in 
%           this case 'levels' gives how many new levels to calculate.
%   x       Points at which f is given.
%
% See also WAVDEMO, WAVELETD.

% (C) 1993-1997 Harri Ojanen

if nargin < 3, f = []; end
if nargin < 4, silent = 0; end

c = c(:)';
c = 2*c/sum(c);
N = length(c);

% Compute exact initial values
if ~length(f)
   %f = ones(N,1);
   A = zeros(N,N);
   for i = 1 : N,
      ind = max(2*i-N,1) : min(2*i-1,N);
      A(i, ind) = c(ind(length(ind) : -1 : 1));
   end
   [V,D]=eig(A);
   D = diag(D);
   i = find(abs(D-1)<1000*eps);
   f = V(:,i);
   s = sum(f);
   if s ~= 0,
      f = f / s;
   end
   if ~silent
       fprintf('Initial data: [ ');
       fprintf('%g ', f);
       fprintf(']\n');
   end    
end

if ~length(f)
    x = [];
    return
end


firstlevel = log((length(f)-1)/(N-1))/log(2) + 1;
lastlevel = firstlevel + levels - 1;

if ~silent, fprintf('Level: ['); end
for n = firstlevel : lastlevel,
   if ~silent, fprintf(' %g', n); end
   newf = zeros((N-1)*2^n+1,1);
   newf(1 : 2 : length(newf)) = f;
   i = 2 : 2 : length(newf)-1;
   j = i;
   step = 2^(n-1);
   for k = 0 : N-1,
      %ok1 = find(j >= 1 & j <= length(f));
      s = ceil((step*k+1)/2);
      t = floor((step*k+length(f))/2);
      ok = s : t;
      jj = j(ok);
      ii = i(ok);
      newf(ii) = newf(ii) + c(k+1) * f(jj);
      j = j - step;
   end
   f = newf;
end;
if ~silent, fprintf(' ]\n'); end

if nargout == 2,
   x = (0 : 2^(-lastlevel) : N-1)';
end
