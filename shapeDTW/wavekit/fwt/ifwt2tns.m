function A = ifwt2tns(s, h, g)

% IFWT2TNS -- inverse fast wavelet transform in a tensor product basis
%
% A = ifwt2tns(s, h, g)
%
% Input:
%   s     Original matrix of wavelet coefficients
%   h,g   Scaling function and wavelet filter coefficients
% 
% Output:
%   A     Inverse transform of s.
%
% See also FWT2TNS, FWT1, IFWT1, FWT2, IFWT2.

% (C) 1997 Harri Ojanen

N=size(s,1);

B = zeros(size(s));
for i=1:N,
    B(:,i) = ifwt1(s(:,i),h,g);
end
    
A = zeros(size(B));
for i=1:N,
    A(i,:) = ifwt1(B(i,:),h,g).';
end
