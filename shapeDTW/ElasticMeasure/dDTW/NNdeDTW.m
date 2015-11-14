function [NNidx, dists] = NNdeDTW(trainset, test)
% the nearest neighbor derivative DTW
% support both univariate and multi-variate time series
% input:    trainset -- a cell array, each element is a training time series
%           test -- a matrix, testing time series
% output:   NNidx -- the index of the nearest training time series
%           dists -- distances to each training time series instance

%% note: make sure, different dimensions are arranged column-wisely!!!

    narginchk(2,2);  
    if ~iscell(trainset) || ~ismatrix(test)
        error('Wrong type of input parameters\n');
    end    
    
    nTrain = numel(trainset);
    dists = zeros(nTrain,1);    
    
    testTS = test;
    parfor i=1:nTrain
        trainTS = trainset{i};

        if ~ismatrix(trainTS)
             error('Wrong content of cell array\n');
        end

        [dDerivative, ~, ~] = deDTW(trainTS, testTS);        
        dists(i) = dDerivative;
    end
    
    [~, NNidx] = min(dists);
    
end
