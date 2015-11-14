function [B,A] = nsexampl(number, size, h, g, packed)

% NSEXAMPL -- some non-standard example matrices and operators
%
% [B,A] = nsexampl(number, size, h, g, packed)
%
% A is the original matrix, B its wavelet transfrom.
%
% h and g are scaling function and wavelet coefficients, 
% A is a size*size matrix.
%
%     number    Operator
%       0         identity
%       1         example 1 (Hilbert-transform) ...
%          ...
%       6         ... example 6 from the paper Beylkin,Coifman,Rokhlin 
%                 (Comm Pure and Applied Math 1993)
%       7         kernel of the conjugate function mapping
%       8         as 7 but with a radial function multiplying the kernel
%       9         related to the first Calderon commutator
%
% The meaning of the optional parameter packed:
% packed == 1     packed version of the operator (see fwt2ns).
% packed == 0     unpacked (much larger)
% packed == -1    B is not computed at all
%
% See also FWT1NS, FWT2, AFUN, HFUN.

% (C) 1993-1997 Harri Ojanen

if nargin < 5, packed = 0; end
[ii,jj] = meshgrid(1:size,1:size);

if number == 0,
    if packed,
        A = eye(size);
        B = A;
    else
        B = zeros(2*size-2,2*size-2);
        while (size >= 2),
            newA = [eye(size/2) zeros(size/2);zeros(size/2) zeros(size/2)];
            n = length(newA);
            B(n-1:2*n-2,n-1:2*n-2)=newA;
            size = size / 2;
        end
        B(2,2)=1;
    end

elseif number == 1,
    % Example 1
    A = 1 ./ (ii-jj+eps) / pi;
    for i=1:size,
         A(i,i)=0;
    end
    if packed >= 0, B = fwt2ns(A,h,g,packed); else B = []; end

elseif number == 2,
    % Example 2
    A = (log(abs(ii-size/2+eps)) - log(abs(jj-size/2+eps))) ./ (ii-jj+eps);
    for i=1:size,
        A(i,i)=0;
        A(i,size/2)=0;
        A(size/2,i)=0;
    end
    if packed >= 0, B = fwt2ns(A,h,g,packed); else B = []; end

elseif number == 3,
    error('Example 3 not implemented');

elseif number == 4, 
    % Example 4
    A = log((ii-jj).^2);
    for i=1:size,
       A(i,i)=0;
    end
    if packed >= 0, B = fwt2ns(A,h,g,packed); else B = []; end

elseif number == 5,
    % Example 5
    A = 1 ./ (ii-jj+0.5*cos(ii.*jj));
    for i=1:size,
       A(i,i)=0;
    end
    if packed >= 0, B = fwt2ns(A,h,g,packed); else B = []; end

elseif number == 6,
    % Example 6
    A = (ii .* cos(log(ii.^2)) - jj .* cos(log(jj.^2))) ./ (ii-jj)^2;
    for i=1:size,
       A(i,i)=0;
    end
    if packed >= 0, B = fwt2ns(A,h,g,packed); else B = []; end

elseif number == 7,
    t = -pi : 2*pi/size : pi-2*pi/size;
    [x,y] = meshgrid(t,t);
    A = 1 ./ (tan((x-y)/2 + eps/10));
    for i = 1 : size,
        A(i,i) = 0;
    end
    if packed >= 0, B = fwt2ns(A,h,g,packed); else B = []; end

elseif number == 8,
    t = -pi : 2*pi/size : pi-2*pi/size;
    [x,y] = meshgrid(t,t);
    A = hfun(abs(x-y)) ./ (tan((x-y)/2 + eps/10));
    for i = 1 : size,
        A(i,i) = 0;
    end
    if packed >= 0, B = fwt2ns(A,h,g,packed); else B = []; end

elseif number == 9,
    t = -pi : 2*pi/size : pi-2*pi/size;
    [x,y] = meshgrid(t,t);
    A = (afun(x)-afun(y)) ./ ((tan((x-y)/2 + eps/10))).^2;
    for i = 1 : size,
        A(i,i) = 0;
    end
    if packed >= 0, B = fwt2ns(A,h,g,packed); else B = []; end

else
    error('Example number out of range.');
end


                               
