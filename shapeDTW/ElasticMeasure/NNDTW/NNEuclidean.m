
function NNidx = NNEuclidean(trainset, test)
% training and test time series should be univariate
% input:    trainset, a cell array, each element is a training time series
%           test,     a vector, testing time series
% output:   the index of the nearest training time series
    
    narginchk(2,2);
    if ~ismatrix(trainset) || ~isvector(test)
        error('The 1st input should be a matrix, and the 2nd one should be a vector\n');
    end
    
    [md1, md2] = size(trainset);
    [vd1, vd2] = size(test);
    
    if vd1 == 1 && vd2 == md2
        trainset = trainset';
        test = test';
    elseif vd2 == 1 && vd1 == md1
    else
        error('Check the dimensionalities of the 1st and 2nd parameters\n');
    end
    
    nTrain = size(trainset,2);
    
    dists = trainset - repmat(test,1,nTrain);
    dists = sum(dists.*dists);
    
    [~, NNidx] = min(dists);
    
end