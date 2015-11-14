function w = bestbase(w, f)

% BESTBASE -- selects the best wavelet packet basis 
%
% w = bestbase(w, f)
%
% See also BESTLEVL, FIXLEVEL, WAVBASIS.

% (C) 1997 Harri Ojanen

if nargin < 2, f = []; end

global MARKED COST SEL
n = prodlog(length(w.wp));

% Compute the costs of the subspaces
totcost(w.wp, n, 2^n, []);

% Select the best subspaces
SEL = zeros(size(w.wp));
select(1, 1, 2^n);
select(1, 2, 2^n);

w.sel = uint8(SEL);


clear MARKED COST SEL


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function c = subscost(scale, freq, w, n, N)

% SUBSCOST -- cost of a single subspace
%
% This program is not meant to be called by the user.
%
% c = subscost(scale, freq, w, n, N)
%
% See also BESTBASE.

global MARKED COST

c = costfn(w(sfptoidx(scale, freq, N)));
if scale == n
    MARKED(scale, freq) = 1;
else
    [ls, lf, rs, rf] = children(scale, freq);
    leftcost = subscost(ls, lf, w, n, N);
    rightcost = subscost(rs, rf, w, n, N);
    if leftcost + rightcost > c
        MARKED(scale, freq) = 1;
    else
        c = leftcost + rightcost;
    end
end

COST(scale, freq) = c;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cost = totcost(w, n, N, f)

% totcost -- cost of all subspaces in the wavelet packet tree
%
% This program is not meant to be called by the user.
%
% cost = totcost(w, n, N, f)
%
% See also BESTBASE.

global MARKED COST

MARKED = zeros(n, N);
COST = zeros(n, N);

leftcost = subscost(1,1,w, n, N);
rightcost = subscost(1,2,w, n, N);

if length(f)
    COST(1,1) = costfn(f);
    if leftcost + rightcost > COST(1,1)
        disp('original vector has lower cost!')
        cost = COST(1,1);
    else
        cost = leftcost + rightcost;
    end
else
    cost = leftcost + rightcost;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function select(scale, freq, N)

% SELECT -- selects the marked subspaces
%
% This program is not meant to be called by the user.
%
% select(scale, freq, N)
%
% See also BESTBASE.

global MARKED SEL

if MARKED(scale, freq)
    i = sfptoidx(scale, freq, N);
    SEL(i) = ones(size(i));
else
    [ls, lf, rs, rf] = children(scale, freq);
    select(ls, lf, N);
    select(rs, rf, N);
end

