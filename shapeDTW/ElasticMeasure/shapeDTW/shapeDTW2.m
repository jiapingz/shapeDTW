function [dRaw,dDescriptor,lPath,match]  = shapeDTW2(p,q, dp, dq, metric)
% since DTW doesn't have shape information, 
% here we describer each point with its local shape, 
% then the univariate time series p & q are transformed into multivariate
% time series

% this one is different from 'shapeDTW' in the following aspect:
% 'shapeDTW.m': shape descriptors are calculated within the function, while
% 'shapeDTW2.m': shape descriptors are input parameters

    narginchk(4,5);
    if ~isvector(p) || ~isvector(q)
        error('Only support univariate time series\n');
    end
    
    if ~ismatrix(dp) || ~ismatrix(dq)
        error('Descriptors should be in the form of matrix\n');
    end
    
    if ~exist('metric', 'var') || isempty(metric)
        metric = 'Euclidean'; % metric = 'chi-square'; 
    end
    
    
    p = p(:);
    q = q(:);
    lenp = length(p);
    lenq = length(q);
    
    if size(dp,1) ~= lenp || size(dq,1) ~= lenq
        error('descriptors should be a nxk matrix, with k being the dimension of descriptor\n');
    end
    
    p_descriptors = dp;    
    q_descriptors = dq;
    
    %% (2) match multivariate time series 'p_descriptors' & 'q_descriptors'
    
	% run DTW
    switch metric
        case 'Euclidean'
            d = dist2(p_descriptors, q_descriptors);
            d = sqrt(d);
        case 'chi-square'
            d = hist_cost_2(p_descriptors, q_descriptors);
        otherwise
            error('Only support two metrics\n');
    end
    [idxp, idxq, cD, pc] = dpfast(d);

	match =[idxp' idxq'];
    lPath = length(idxp);
%     dDescriptor = cD;
%     dist = cD(lenp,lenq);
    dDescriptor = sum(pc);
    
    % compute distance using raw signals, instead of descriptor distances
    wp = wpath2mat(idxp) * p;
    wq = wpath2mat(idxq) * q;
    
    %dRaw = norm(wp - wq);
	dRaw = sum(sqrt((wp-wq).^2));
    

end