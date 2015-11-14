function [A,B,C] = varfwt2(a, b, c, h, g, lastlevel)

% VARFWT2 -- a variation of fwt2ns for demonstration purposes
%
% [R,G,B] = varfwt2(red, green, blue, h, g, lastlevel)
%
% This is a combination of fwt2ns and fwt2 with extra scaling:
% each submatrix is scaled between 0 and 1. The same scaling
% is used for corresponding submatrices of a, b and c.
%
% For gray scale images this routine can also be called in the form
% G = varfwt2(gray, h, g, lastlevel)
%
% See also FWT2.

% (C) 1997 Harri Ojanen

if nargout == 1,
    if nargin < 4,
        lastlevel = 1;
    else
        lastlevel = h;
    end
    grayscale = 1;
    g = c;
    h = b;
elseif nargout == 3,
    grayscale = 0;
    if nargin < 6,
        lastlevel = 1;
    end
else
	error('Number of output arguments must be either 1 or 3.');
end

n = size(a,1);
A = zeros(n,n);

while (length(a) >= lastlevel*2),
    if grayscale
        [aalpha, abeta, agamma, anew] = fwt2step(a, h, g);
        aalpha = comscale(aalpha);
        abeta = comscale(abeta);
        agamma = comscale(agamma);
        newA = [zeros(length(agamma)) abeta; agamma aalpha];
        n = length(newA);
        A(1:n, 1:n)=newA;
        a = anew;
    else
        [aalpha, abeta, agamma, anew] = fwt2step(a, h, g);
        [balpha, bbeta, bgamma, bnew] = fwt2step(b, h, g);
        [calpha, cbeta, cgamma, cnew] = fwt2step(c, h, g);
        [aalpha, balpha, calpha] = comscale(aalpha, balpha, calpha);
        [abeta, bbeta, cbeta] = comscale(abeta, bbeta, cbeta);
        [agamma, bgamma, cgamma] = comscale(agamma, bgamma, cgamma);
        newA = [zeros(length(agamma)) abeta; agamma aalpha];
        newB = [zeros(length(bgamma)) bbeta; bgamma balpha];
        newC = [zeros(length(cgamma)) cbeta; cgamma calpha];
        n = length(newA);
        A(1:n, 1:n)=newA;
        B(1:n, 1:n)=newB;
        C(1:n, 1:n)=newC;
        a = anew;
        b = bnew;
        c = cnew;
    end
end

n = length(a);

if grayscale
    A(1:n,1:n) = comscale(a);
else
    [A(1:n,1:n),B(1:n,1:n),C(1:n,1:n)] = comscale(a,b,c);
end



fprintf('\r                                                       \r');
