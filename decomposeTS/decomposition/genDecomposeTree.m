function decomposedTree = genDecomposeTree(TS, samplingSetting, descriptorSetting, ...
                                                                clusteringSetting, decomposeTreeSetting)
% this function aims to decompose multivariate time series into segments
% inputs:   
%            TS                                -  uni-variate
%                                                   time series (applicable
%                                                   to univariate times
%                                                   series as well)
%           samplingSetting             -  sample subsequences from time
%                                                   series
%           clusteringSetting            -  clustering method to symbolize time series 
%           descriptorSetting            -  calculate descriptors for time
%                                                   series
%           decompositionSetting     -   decompose time series into
%                                                   segments

    narginchk(1,5);
    if ~exist('TS', 'var') || isempty(TS) || ~isvector(TS)
        error('Input the univariate time series data\n');
    end
    
 
    
    %% validate inputs
    if ~exist('samplingSetting', 'var') || isempty(samplingSetting)
        samplingSetting = struct('method', 'hybrid', ...
                                             'param', struct('sel', 8, 'seqlen', 62, 'stride', 30));
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
                                               'param', struct('nclusters', 10, ...
                                                                     'EmptyAction', 'singleton', ...
                                                                     'MaxIter', 100));
        clusteringSetting = validateClusteringSetting(clusteringSetting);
    end
    
    nclusters = clusteringSetting.param.nclusters;
    
    if ~exist('decomposeTreeSetting', 'var') || isempty(decomposeTreeSetting)
        splitModel = struct('criterion', 'entropy', ...
                                     'nclasses', nclusters, ...
                                     'dissimilarity', []);
        splitModel = validateSplitModel(splitModel);
        
        decomposeTreeSetting = struct('depth', 10, ...
                                                        'minlen', 180, ...
                                                        'splitModel', splitModel); 
        
    end
    
    %% decompose time series    
    iTS = TS(:); 
    [symbols, subsequencesIdx, markers] =  ...
        symbolizeTSindividually(iTS, samplingSetting, descriptorSetting, clusteringSetting);
    t = buildDecomposeTree(iTS, subsequencesIdx, markers, ...
                                        symbols, decomposeTreeSetting);  
    decomposedTree = t;
     
end