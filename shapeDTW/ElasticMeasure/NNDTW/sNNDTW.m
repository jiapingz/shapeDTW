% first smooth the data set
% then perform dynamic time warping on the smoothed data set
function  [NNidx, dists] = sNNDTW(trainset, test, sParam)
    narginchk(2,3);
    if nargin == 2
        sParam = validateSmoothparam;
    else
        sParam = validateSmoothparam(sParam);
    end
    
    nTrain = numel(trainset);
    sTrainset = cell(nTrain,1);
    for i=1:nTrain
        t = trainset{i};
        t = t(:);
        sTrainset{i} = smooth(t, sParam.span, sParam.method);
    end    
    
    sTest = smooth(test(:), sParam.span, sParam.method);
    [NNidx, dists] = NNDTW2(sTrainset, sTest);
end

