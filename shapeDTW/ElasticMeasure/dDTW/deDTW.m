function [dDerivative, dRaw, match] = deDTW(sequence1, sequence2)
% derivative DTW: Keogh, 2001
% two steps: (1) calculate derivatives
%            (2) run dynamic time warping

% inputs:   sequence1, m1xn
%           sequence2, m2xn, where n -- dimensions, m1, m2 -- # of time
%                      stamps

% outputs:  dDerivative, cumulative distances along the warping path,
%                        distances calculated among derivatives
%           dRaw,        cumulative distances along the warping path,
%                        distances calculated among raw sequences
%           match, px2 matrix, warnping path

  narginchk(2,2);

 if ~exist('sequence1', 'var') || isempty(sequence1) || ...
         ~exist('sequence2', 'var') || isempty(sequence2) 
     warning('input two univariate/multivariate time series instance\n');
 end
 
 [len1, dims1] = size(sequence1);
 [len2, dims2] = size(sequence2);
 
 if len1 < dims1 || len2 < dims2
     warning('Each dimension of time series should be organized column-wisely\n');
 end
 
 if dims1 ~= dims2
     error('Two time series should be have the same dimensions\n');
 end
 
    p = sequence1;
    q = sequence2;
% 1. calculate derivatives
	grads_p = calcKeoghGradient(p);
    grads_q = calcKeoghGradient(q);
    
% 2. run DTW
    d = dist2(grads_p, grads_q);
    d = sqrt(d);
    [idxp, idxq, cD, pc] = dpfast(d);
    
	match =[idxp' idxq'];
    dDerivative = sum(pc);
    
    % compute distance using raw signals, instead of descriptor distances
    wp = wpath2mat(idxp) * p;
    wq = wpath2mat(idxq) * q;
    
	dRaw = sum(sqrt(sum((wp-wq).^2,2)));
    
end