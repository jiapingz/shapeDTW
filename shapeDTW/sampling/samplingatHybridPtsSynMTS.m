% now sampling from multivariate time series
% but the feature points are found from only one dimension
% synchronized MTS

function [subsequences, subsequenceIdx] = ...
                    samplingatHybridPtsSynMTS(sensordata, anchorDimension, sel, seqlen, stride)

% sampling sequences from each time series
% samples sequences from feature points, 
% while at flat regions, sampling evenly

    if ~ismatrix(sensordata) && ~isvector(sensordata)
        error('The 1st input parameter must be of matrix type\n');
    end

  
    % first feature points & points in the flat regions
    subsequenceIdx = findHybridPoints(sensordata(:, anchorDimension), sel, stride);
    % then do the sampling    
    [subsequences, subsequenceIdx] ...
            = samplingSequencesIdx(sensordata, seqlen, subsequenceIdx);   

end