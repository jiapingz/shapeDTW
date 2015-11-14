function [NNidxRaw, NNidxDescriptor, distsRaw, distsDescriptor] = ...
                             NNshapeDTW2(trainset, test, dtrainset, dtest, metric)
% nearest neighbor shape DTW
% training and test time series should be univariate
% input:    trainset, a cell array, each element is a training time series
%           test,     a vector, testing time series
%           dtrainset, a cell array, each element is descriptor of training time series
%           dtest, a matrix, the descriptor of the test time series
% output:   the index of the nearest training time series

    narginchk(4,5);
    
    if ~iscell(trainset) || ~isvector(test)
        error('The 1st input should be cell, and the 2nd one should be a vector\n');
    end    
    
    if ~iscell(dtrainset) || ~ismatrix(dtest)
        error('Wrong type of the 3rd & 4th parameters\n');
    end
    
	if ~exist('metric', 'var') || isempty(metric)
        metric = 'Euclidean'; % metric = 'chi-square'; 
    end
    
    
    nTrain          = numel(trainset);
    distsRaw        = zeros(nTrain,1);    
    distsDescriptor = zeros(nTrain,1);
    
    testTS = test(:);
    parfor i=1:nTrain
        trainTS = trainset{i};
        dtrainTS = dtrainset{i};
        if ~isvector(trainTS)
             error('Only support univariate time series\n');
        end        
        trainTS = trainTS(:);        
%         dists(i) = dtw_c(trainTS, testTS);
        [distsRaw(i), distsDescriptor(i)]  = shapeDTW2(trainTS, testTS, dtrainTS, dtest, metric);
    end
    
    [~, NNidxRaw] = min(distsRaw);
    [~, NNidxDescriptor] = min(distsDescriptor);
    
end
