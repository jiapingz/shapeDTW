function y = bitrev(x, wordlength)

% BITREV -- bit reverses integers
%
% y = bitrev(x, wordlength) produces a column vector y whose entries 
% are the bit reverses of the (nonnegative integer) entries in x.
% The reversal is with respect to 'wordlength' number of bits.

% (C) 1997 Harri Ojanen

x = x(:);
bits = int2bits(x, wordlength);
y = bits2int(bits(:, size(bits,2) : -1 : 1));

