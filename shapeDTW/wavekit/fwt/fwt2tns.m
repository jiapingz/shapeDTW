function A = fwt2tns(s, h, g)

% FWT2TNS -- two dimensional fast wavelet transform in a tensor product basis
%
% A = fwt2tns(s, h, g)
%
% Input:
%   s     Original matrix 
%   h,g   Scaling function and wavelet coefficients
% 
% Output:
%   A     Resulting two dimensional multi-scale analysis (tensor
%         product basis)
%
% See also IFWT2TNS, FWT1, IFWT1, FWT2, IFWT2.

% (C) 1993-1997 Harri Ojanen

N=size(s,1);

B = zeros(size(s));
for i=1:N,
    B(i,:) = fwt1(s(i,:),h,g).';
end
    
A = zeros(size(B));
for i=1:N,
    A(:,i) = fwt1(B(:,i),h,g);
end
