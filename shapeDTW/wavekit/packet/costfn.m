function y = costfn(x,s)

% COSTFN -- cost function used to select the best basis
%
% y = costfn(x,s)
%
% This program is not meant to be called by the user.
%
% Depending on the value of the global variable COSTFN, the following
% is computed:
%
% COSTFN < 1000     pth power of the Lp-norm of x, where p = COSTFN
% COSTFN = 2000     L2 entropy (no normalization)
% 3000 <= COSTFN < 4000
%                   the number of entries with absolute value larger
%                   than the threshold given by COSTFN - 3000
%
% See also BESTBASE.

% (C) 1997 Harri Ojanen


global COSTFN
if ~length(COSTFN)
    COSTFN = 2000;
end

if nargin < 2
    s = 0;
end

if ~s
    x = x(:);
end
	
% Lp-norm
if COSTFN < 1000
    if ~s
        y = sum(abs(x) .^ COSTFN);
    else
        y = abs(x) .^ COSTFN;
    end


% Entropy with normalization
% elseif COSTFN == 1000
%    if ~s
%        normx = norm(x,2);
%        if normx > 0
%            x = abs(x) / normx;
%            y = -sum(x .* log(x + realmin));
%        else
%            y = 0;
%        end
%    else
%        disp('not yet implemented')
%    end

% L2 entropy, no normalization        
elseif COSTFN == 2000
    if ~s
        aux = x.^2;
        y = -sum(aux .* log(aux+realmin));
    else
        aux = x.^2;
        y = -(aux .* log(aux+realmin));
    end
        
% Counting entries above a threshold
elseif COSTFN >= 3000 & COSTFN < 4000
    if ~s
        y = sum(abs(x) > (COSTFN - 3000));
    else
        y = abs(x) > (COSTFN - 3000);
    end 
end
