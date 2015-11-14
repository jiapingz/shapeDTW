function grads = calcKeoghGradient(sequence)
% usable for both univariate and multivariate time series
% input - sequence, mxn, m -- # of time stamps
%                        n -- # of dimensions
%                   generally, m >> n, if not, pop up a warning

 if ~exist('sequence', 'var') || nargin ~= 1
     warning('input an univariate/multivariate time series instance\n');
 end
 
 [len, dims] = size(sequence);
 if len < dims
     warning('Each dimension of time series should be organized column-wisely\n');
 end
 
 grads = [];
 
 for i=1:dims
     grads = cat(2,grads, calcKeoghGradient1D(sequence(:,i)));
 end

end