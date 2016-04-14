% symbolization of time series, several steps include:
% 1. sampling, e.g. hybrid
% 2. descriptors, e.g. hog1d
% 3. clustering, k-means(default), normalized cut(jianbo shi),
%                graclus(Dhillon), self tuning (manor)
% 4. assignment, fixed to use kmeans centers

% difference from 'symbolizeTSindividually.m'
% this function is specicially designed for symbolized multi-variate time
% series(MTS)
% while the former one is designed for one-dimensional time series

% # { By the way, this function is also applicable to one-dimensional time
% series } #

function varargout =  ...
      symbolizeSynMTSindividually(MTS, samplingSetting, descriptorSetting, clust_method, clust_param)
    
    narginchk(5,5);
    [nTimeStamps, nDims] = size(MTS);
    if nTimeStamps < nDims
        warning('Synchronized signals should be arranged column-wisely\n');
    end
    % 1.sampling
    samplingSetting = validateSamplingSetting(samplingSetting);
    sel = samplingSetting.param.sel;
    stride = samplingSetting.param.stride;
    seqlen = samplingSetting.param.seqlen;
    samplingMethod = samplingSetting.method;
    
    sensordata = MTS;
	switch samplingMethod
        case 'hybrid'
            if nDims > 1
                [subsequences, subsequenceIdx] = ...
                        samplingatHybridPtsSynMTS2(sensordata, sel, seqlen, stride);
            else
                [subsequences, subsequenceIdx, markers] = ...
                        samplingatHybridPts(sensordata, sel, seqlen, stride);                
            end
        case 'evenly'
            [subsequences, subsequenceIdx] = ...
                        samplingEvenly(sensordata, seqlen, stride);
             markers = zeros(numel(subsequenceIdx),1);
        case 'randomly'
            [subsequences, subsequenceIdx] = ...
                        samplingRandomly(sensordata, seqlen, stride);
             markers = zeros(numel(subsequenceIdx),1);
        otherwise
            error('Only support three kinds of sampling methods\n');
    end
    
    % 2.descriptor
    if ~isfield(descriptorSetting, 'method')
        descriptorName = 'hog1d';
    else
        descriptorName = descriptorSetting.method;
    end
    
    if ~isfield(descriptorSetting, 'param')
        descriptorParam = validateHOG1Dparam;
    else
        descriptorParam = descriptorSetting.param;
    end
    
    nsubsequences = numel(subsequences);
    descriptors   = cell(nsubsequences,1);

    parfor j=1:nsubsequences
        seq = subsequences{j};
        for d=1:nDims
            descriptors{j} = cat(2, descriptors{j}, ...
                    calcDescriptor(seq(:,d), descriptorName, descriptorParam));
        end
    end
    
    
    % 3.clustering
    partition = doClustering(cell2mat(descriptors), clust_method, clust_param);
    
    assignments = partition;
    % assignments
%     assignments = assignmentKMeans(cell2mat(descriptors), Centers);

    if nDims == 1
        varargout = {assignments, subsequenceIdx, markers};
    else
        varargout = {assignments, subsequenceIdx, zeros(length(subsequenceIdx),1)};
    end
           
end