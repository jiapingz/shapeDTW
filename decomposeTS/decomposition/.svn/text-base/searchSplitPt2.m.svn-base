% this function is different from 'searchSplitPt' in the following aspect
% it relys on additional parameter 'markers'
% 'markers' belong to {-1 0 1}
% -1: valleys, 0: flat, 1: peaks

% find the split point, which make the information gain maximal
function [splitPt, gain] = searchSplitPt2(symbols, markers, splitModel)   
    narginchk(3,3);
    splitModel = validateSplitModel(splitModel);
%     criterion = splitModel.criterion;
%     nclasses  = splitModel.nclasses;
%     dissimilarity = splitModel.dissimilarity;

    if ~isnumeric(symbols) || min(symbols) < 1 || ...
            sum(floor(symbols) == symbols) ~= numel(symbols)
        error('Symbols should be an integer vector, starting at 1 ...\n');
    end    
    
    len = numel(symbols);   
    gains = zeros(1,len);
    
    for i=1:len
%         gains(i) = infoGain(symbols, nclasses, i);
        gains(i) = splitGoodness2(symbols, markers, i, splitModel);
    end    
    [gain, splitPt] = max(gains);
    
end