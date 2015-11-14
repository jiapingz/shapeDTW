% first smooth the data set
% then perform dynamic time warping on the smoothed data set
function  NNidx = sNNEuclidean(trainset, test, sParam)
    narginchk(2,3);
    
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
    
    if nargin == 2
        sParam = validateSmoothparam;
    else
        sParam = validateSmoothparam(sParam);
    end
        
    nTrain = size(trainset,2);
    sTrainset = trainset;
    for i=1:nTrain
        t = trainset(:,i);
        t = t(:);
        sTrainset(:,i) = smooth(t, sParam.span, sParam.method);
    end    
    
    sTest = smooth(test(:), sParam.span, sParam.method);
    NNidx = NNEuclidean(sTrainset, sTest);
end
