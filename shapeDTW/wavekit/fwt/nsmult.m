function y = nsmult(A, f)

% NSMULT -- multiply an operator with a non-standard msa
%
% y = nsmult(A, f)
%
% Input:
%    A  is the operator, as given by fwt2ns, with option packed==1
%    f  is the wavelet transform of your function, as given by fwt1ns
%
% Output:
%    y  contains the wavelet coefficients of A(f).

% (C) 1993-1997 Harri Ojanen

n = round(log(length(A))/log(2));
if abs(log(length(A))/log(2) - n) > 10*eps,
   error('Size of A must be 2^n*2^n: only packed operators are supported!');
end

y = zeros(length(f), 1);

for i = 0 : n-1,
   i2 = 2^i;
   alpha = A(i2+1 : 2*i2, i2+1 : 2*i2);
   beta = A(1 : i2, i2+1 : 2*i2);
   gamma = A(i2+1 : 2*i2, 1 : i2);
   d = nsmsalvl(f, i, 'd');
   s = nsmsalvl(f, i, 's');
   dnew = alpha * d + beta * s;
   if i,
     snew = gamma * d;
   else
     snew = gamma * d + A(1,1) * s;
   end
   y(2*i2-1 : 4*i2-2) = [dnew; snew];
end


