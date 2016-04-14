% symbolization of time series, several steps include:
% 1. sampling, e.g. hybrid
% 2. descriptors, e.g. hog1d
% 3. assignment, fixed to use kmeans centers

% difference from 'symbolizeTSindividually.m'
% 'centers' are computed by k-means, based on the whole time series data
% set

function [assignments, subsequenceIdx, markers] =  ...
      symbolizeTS(TS, samplingSetting, descriptorSetting, centers)
    
    narginchk(4,4);    
    % 1.sampling
    samplingSetting = validateSamplingSetting(samplingSetting);
    sel = samplingSetting.param.sel;
    stride = samplingSetting.param.stride;
    seqlen = samplingSetting.param.seqlen;
    samplingMethod = samplingSetting.method;
    
    sensordata = TS(:);
	switch samplingMethod
        case 'hybrid'
            [subsequences, subsequenceIdx, markers] = ...
                        samplingatHybridPts(sensordata, sel, seqlen, stride);
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

    for j=1:nsubsequences
        seq = subsequences{j};
        descriptors{j} = calcDescriptor(seq, descriptorName, descriptorParam);
    end
    
    % assignments
    assignments = assignmentKMeans(cell2mat(descriptors), centers);
           
end