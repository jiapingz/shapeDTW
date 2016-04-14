
function [subsequences, subsequenceIdx, marker] = ...
                        samplingatHybridPts(sensordata, sel, seqlen, stride)

% sampling sequences from each time series
% samples sequences from feature points, 
% while at flat regions, sampling evenly

    if ~ismatrix(sensordata) && ~isvector(sensordata)
        error('The 1st input parameter must be of matrix type\n');
    end

   
    if numel(sensordata) ~= max(size(sensordata))
        error('The 1st input should be 1-D time series\n');
    end
    
    % first feature points & points in the flat regions
    [subsequenceIdx, marker] = findHybridPoints(sensordata(:), sel, stride);
%     [subsequenceIdx, marker] = findHybridPoints2(sensordata(:), sel, stride, seqlen);
    % then do the sampling    
    [subsequences, subsequenceIdxLeft] ...
            = samplingSequencesIdx(sensordata(:), seqlen, subsequenceIdx);    

    % find the mapping
    nLeft = numel(subsequenceIdxLeft);
    mapping = zeros(nLeft,1);
    for i=1:nLeft
        rIdx = subsequenceIdxLeft(i);
        matchedIdx = find(subsequenceIdx == rIdx);
        mapping(i) = matchedIdx(1);
    end
    marker = marker(mapping); 
    subsequenceIdx = subsequenceIdxLeft;
end