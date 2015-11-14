function [distRaw,distDescriptor,lPath,match]  = ...
                        shapeDTWmulti(p,q, seqlen, descriptorSetting, metric)
% since DTW doesn't have shape information, 
% here we describer each point with its local shape, 
% then the univariate time series p & q are transformed into multivariate
% time series
    narginchk(3,5);
    if ~ismatrix(p) || ~ismatrix(q)
        error('only applicable to multivariate time series\n');
    end
    
    if ~exist('p', 'var') || ~exist('q', 'var') ...
            || isempty(p)  || isempty(q)
        return;
    end
    
    if size(p,2) ~= size(q,2)
        error('make sure p & q have the same dimensions\n');
    end
        
    if ~exist('metric', 'var') || isempty(metric)
        metric = 'Euclidean';
    end
    

    [lenp,~] = size(p);
    [lenq, dims] = size(q);
    
    if ~exist('descriptorSetting', 'var') || isempty(descriptorSetting)
        hog = validateHOG1Dparam;
        hog.cells    = [1 round(seqlen/2)-1];
        hog.overlap = 0; %round(seqlen/4);
        hog.xscale  = 0.1;
        
        dsp = validateDSPparam;
        dsp.nScales = 3;
        dsp.rScales = [0.5  1];
        dsp.pooling = 'sum';
        
        hogdsp = validateHOG1DDSPparam;
        hogdsp.HOG1D = hog;
        hogdsp.DSP = dsp;

        paa = validatePAAdescriptorparam;
        paa.priority = 'segNum';
        segNum = ceil(seqlen/5);
        paa.segNum = segNum;

        numLevels = 3;
        dwt = validateDWTdescriptorparam;
        dwt.numLevels = numLevels;

        hogpaa = validateHOG1DPAAdescriptorparam;
        hogpaa.HOG1D = hog;
        hogpaa.PAA = paa;
        
        self = [];

%         descriptorSetting = struct('method', 'HOG1D', ...
%                                              'param', hog);
%         descriptorSetting = struct('method', 'PAA', ...
%                                         	 'param', paa);
%         descriptorSetting = struct('method', 'HOG1D', ...
%                                              'param', hog);
        descriptorSetting = struct('method', 'self', ...
                                             'param', self);
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
    len_des = 0;
    for j=1:p_nsubsequences
        seq = p_subsequences{j};
        tmp_des = [];
        for k=1:dims
            tmp_des = cat(1, tmp_des, calcDescriptor(seq(:,k), descriptorName, descriptorParam));
            len_des = size(tmp_des,2);
        end
        p_descriptors{j} = tmp_des;
    end
%     p_descriptors = cell2mat(p_descriptors);
    
	q_nsubsequences = numel(q_subsequences);
    q_descriptors   = cell(q_nsubsequences,1);
    for j=1:q_nsubsequences
        seq = q_subsequences{j};
        tmp_des = [];
        for k=1:dims
            tmp_des = cat(1, tmp_des, calcDescriptor(seq(:,k), descriptorName, descriptorParam));
        end
        q_descriptors{j} = tmp_des;
    end
%     q_descriptors = cell2mat(q_descriptors);
    
    %% (2) match multivariate time series 'p_descriptors' & 'q_descriptors'
    
	% run DTW
    switch metric
        case 'Euclidean'
%             d = dist2(p_descriptors, q_descriptors);
%             d = sqrt(d);
              q_des = cell2mat(q_descriptors);
              q_des = reshape(q_des', len_des*dims, q_nsubsequences);

              d = zeros(p_nsubsequences, q_nsubsequences);
              parfor i=1:p_nsubsequences
                i_des = p_descriptors{i};
                i_des = i_des(:);
                d(i,:) = sum((repmat(i_des,1, q_nsubsequences) - q_des).^2);
              end
             d = sqrt(d);

        case 'chi-square'
%             d = hist_cost_2(p_descriptors, q_descriptors);
              d = zeros(p_nsubsequences, q_nsubsequences);
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