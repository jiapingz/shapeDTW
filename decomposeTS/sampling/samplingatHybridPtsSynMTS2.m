% now sampling from synchronized MTS
% difference from 'samplingatHybridPtsSynMTS.m'
% the former one finds feature points from only one dimensions, while the
% latter one finds feature points from all time series, and then combine
% them

function [subsequences, subsequenceIdx] = ...
                    samplingatHybridPtsSynMTS2(sensordata, sel, seqlen, stride)

% sampling sequences from each time series
% samples sequences from feature points, 
% while at flat regions, sampling evenly

    if ~ismatrix(sensordata) && ~isvector(sensordata)
        error('The 1st input parameter must be of matrix type\n');
    end

  
    % first feature points & points in the flat regions
    subsequenceIdx = findHybridPointsSynMTS(sensordata, sel, stride);
    % then do the sampling    
    [subsequences, subsequenceIdx] ...
            = samplingSequencesIdx(sensordata, seqlen, subsequenceIdx);   

end