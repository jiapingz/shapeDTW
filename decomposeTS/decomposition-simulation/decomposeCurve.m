
function decomposedTree = decomposeCurve(curve, samplingSetting, descriptorSetting, ...
                             clusteringSetting, decomposeTreeSetting)


    narginchk(1,5);
    if ~exist('curve', 'var') || isempty(curve) || ~isvector(curve)
        error('Input the univariate time series data\n');
    end
    
 
    
    %% validate inputs
    if ~exist('samplingSetting', 'var') || isempty(samplingSetting)
        samplingSetting = struct('method', 'hybrid', ...
                                 'param', struct('sel', 5, 'seqlen', 30, 'stride', 5));
    end
    
    samplingSetting = validateSamplingSetting(samplingSetting);
    seqlen = samplingSetting.param.seqlen;
    if ~exist('descriptorSetting', 'var') || isempty(descriptorSetting)
        hog = validateHOG1Dparam;
        hog.cells    = [1 round(seqlen/2)-1];
        hog.overlap = 0; %round(seqlen/4);
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
                            	   'param', struct('nclusters', 20, ...
                                                    'EmptyAction', 'singleton', ...
                                                    'MaxIter', 100));
        clusteringSetting = validateClusteringSetting(clusteringSetting);
    end
    
    nclusters = clusteringSetting.param.nclusters;
    
    if ~exist('decomposeTreeSetting', 'var') || isempty(decomposeTreeSetting)
        splitModel = struct('criterion', 'entropy', ...
                            'nclasses',   nclusters, ...
                            'dissimilarity', []);
        splitModel = validateSplitModel(splitModel);
        
        decomposeTreeSetting = struct('depth', 10, ...
                                      'minlen', 200, ...
                                      'splitModel', splitModel); 
        
    end

    decomposedTree = genDecomposeTree(curve, samplingSetting, descriptorSetting, ...
                                                clusteringSetting, decomposeTreeSetting);
                                                            
    if nargout == 0
        plotDecomposedTree(decomposedTree);
    end

end