function [NNidxRaw, NNidxDescriptor, distsRaw, distsDescriptor] ...
                    = NNshapeDTW(trainset, test, seqlen, descriptorSetting)
% nearest neighbor shape DTW
% training and test time series should be univariate
% input:    trainset, a cell array, each element is a training time series
%           test,     a vector, testing time series
% output:   the index of the nearest training time series
    narginchk(2,4);
    
    if ~exist('seqlen', 'var') || isempty(seqlen)
        seqlen = 20;
    end
    
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
    
    if ~iscell(trainset) || ~isvector(test)
        error('The 1st input should be cell, and the 2nd one should be a vector\n');
    end    
    
    nTrain = numel(trainset);
    distsRaw = zeros(nTrain,1);  
	distsDescriptor = zeros(nTrain,1);

    
    testTS = test(:);
    for i=1:nTrain
        trainTS = trainset{i};

        if ~isvector(trainTS)
             error('Only support univariate time series\n');
        end
        trainTS = trainTS(:);        
%         dists(i) = dtw_c(trainTS, testTS);
        [distsRaw(i), distsDescriptor(i)]  = ...
                shapeDTW(trainTS, testTS, seqlen, descriptorSetting);
    end
    
    [~, NNidxRaw] = min(distsRaw);
    [~, NNidxDescriptor] = min(distsDescriptor);
    
end
