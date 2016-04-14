
% find the split point, which make the information gain maximal
function varargout = searchSplitPt(symbols, splitModel)   
    narginchk(2,2);
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
        gains(i) = splitGoodness(symbols, i, splitModel);
    end    
    [splitPtGain, splitPt] = max(gains);
    
    varargout = {splitPt, splitPtGain, gains};
    
end