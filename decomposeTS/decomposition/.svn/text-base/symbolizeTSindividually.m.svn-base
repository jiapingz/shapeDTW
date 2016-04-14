% symbolization of time series, several steps include:
% 1. sampling, e.g. hybrid
% 2. descriptors, e.g. hog1d
% 3. clustering, k-means(default), normalized cut(jianbo shi),
%                graclus(Dhillon), self tuning (manor)
% 4. assignment, fixed to use kmeans centers

function [assignments, subsequenceIdx, markers] =  ...
      symbolizeTSindividually(TS, samplingSetting, descriptorSetting, clusteringSetting)
    
    narginchk(1,4);
    
    %% validate parameters
    if ~exist('samplingSetting', 'var') || isempty(samplingSetting)
        samplingSetting = struct('method', 'hybrid', ...
                                             'param', struct('sel', 30, 'seqlen', 20, 'stride', 5));
    end
    
    samplingSetting = validateSamplingSetting(samplingSetting);
    seqlen = samplingSetting.param.seqlen;
    if ~exist('descriptorSetting', 'var') || isempty(descriptorSetting)
        hog = validateHOG1Dparam;
        hog.cells    = [1 round(seqlen/2)];
        hog.overlap = 0;
        hog.xscale  = 0.1;

        paa = validatePAAdescriptorparam;
        paa.priority = 'segNum';
        segNum = ceil(seqlen/5);
        paa.segNum = segNum;

        numLevels = 3;
        dwt = validateDWTdescriptorparam;
        dwt.numLevels = numLevels;

        descriptorSetting = struct('method', 'HOG1D', ...
                                               'param', hog);
    end
    
    if ~exist('clusteringSetting', 'var') || isempty(clusteringSetting)
        clusteringSetting = struct('method', 'kmeans', ...
                                               'param', struct('nclusters', 40, ...
                                                                     'EmptyAction', 'singleton', ...
                                                                     'MaxIter', 100));
        clusteringSetting = validateClusteringSetting(clusteringSetting);
    end
    
    %% do symbolization
    % 1.sampling
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
    descriptorName = descriptorSetting.method; 
    descriptorParam = descriptorSetting.param;
     
    nsubsequences = numel(subsequences);
    descriptors   = cell(nsubsequences,1);

    for j=1:nsubsequences
        seq = subsequences{j};
        descriptors{j} = calcDescriptor(seq, descriptorName, descriptorParam);
    end
    
    
    % 3.clustering
    clust_method = clusteringSetting.method;
    clust_param   = clusteringSetting.param;
    partition = doClustering(cell2mat(descriptors), clust_method, clust_param);
    
    assignments = partition;
    % assignments
%     assignments = assignmentKMeans(cell2mat(descriptors), Centers);
           
end