function [distRaw,distDescriptor,lPath,match]  = ...
                        shapeDTW(p,q, seqlen, descriptorSetting, metric)
% since DTW doesn't have shape information, 
% here we describer each point with its local shape, 
% then the univariate time series p & q are transformed into multivariate
% time series
    narginchk(3,5);
    if ~isvector(p) || ~isvector(q)
        error('Only support univariate time series\n');
    end
    
    if ~exist('metric', 'var') || isempty(metric)
        metric = 'Euclidean';
    end
    
    p = p(:);
    q = q(:);
    lenp = length(p);
    lenq = length(q);
    
    if ~exist('descriptorSetting', 'var') || isempty(descriptorSetting)
        hog = validateHOG1Dparam;
        hog.cells    = [1 round(seqlen/2)-1];
        hog.overlap = 0;  
        hog.xscale  = 0.1;
        
  
        paa = validatePAAdescriptorparam;
        paa.priority = 'segNum';
        segNum = ceil(seqlen/5);
        paa.segNum = segNum;

        numLevels = 3;
        dwt = validateDWTdescriptorparam;
        dwt.numLevels = numLevels;
        
        self = [];

%         descriptorSetting = struct('method', 'DWT', ...
%                                              'param', dwt);
%         descriptorSetting = struct('method', 'PAA', ...
%                                         	 'param', paa);
        descriptorSetting = struct('method', 'HOG1D', ...
                                             'param', hog);
%         descriptorSetting = struct('method', 'self', ...
%                                              'param', self);
    end
    
    %% (1) first compute descriptor at each point, and transform
    % the univariate time series to multivariate one
        
     % 1.evenly sampling, specifically, sampling at each point
%     p_subsequences  = samplingEvenly(p, seqlen, stride);
%     q_subsequences  = samplingEvenly(q, seqlen, stride);
    p_subsequences = samplingSequencesIdx(p, seqlen, 1:lenp);   
    q_subsequences = samplingSequencesIdx(q, seqlen, 1:lenq);   
    
    % 2.descriptor 
    descriptorName = descriptorSetting.method; 
    descriptorParam = descriptorSetting.param;
     
    p_nsubsequences = numel(p_subsequences);
    p_descriptors   = cell(p_nsubsequences,1);
    for j=1:p_nsubsequences
        seq = p_subsequences{j};
        p_descriptors{j} = calcDescriptor(seq, descriptorName, descriptorParam);
    end
    p_descriptors = cell2mat(p_descriptors);
    
	q_nsubsequences = numel(q_subsequences);
    q_descriptors   = cell(q_nsubsequences,1);
    for j=1:q_nsubsequences
        seq = q_subsequences{j};
        q_descriptors{j} = calcDescriptor(seq, descriptorName, descriptorParam);
    end
    q_descriptors = cell2mat(q_descriptors);
    
    %% (2) match multivariate time series 'p_descriptors' & 'q_descriptors'
    
	% run DTW
    switch metric
        case 'Euclidean'
            d = dist2(p_descriptors, q_descriptors);
            d = sqrt(d);
        case 'chi-square'
            d = hist_cost_2(p_descriptors, q_descriptors);
        otherwise
            error('Only support two distance metrics\n');
    end
    
    [idxp, idxq, cD, pc] = dpfast(d);

	match =[idxp' idxq'];
    lPath = length(idxp);
%     distDescriptor = cD;
%     dist = cD(lenp,lenq);
    distDescriptor = sum(pc);
    
    % compute distance using raw signals, instead of descriptor distances
    wp = wpath2mat(idxp) * p;
    wq = wpath2mat(idxq) * q;
    
%     distRaw = norm(wp - wq);
    distRaw = sum(sqrt((wp-wq).^2));
    

end