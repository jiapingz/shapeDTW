% sampling MTS from: hybrid, evenly, randomly
% Now hybrid sampling has to rely on some axis

function [subsequences, subsequenceIdx] = ...
                    runSamplingSynMTS(synMTS, samplingMethod, sel, seqlen, stride, anchorDimension)
     
    if nargin < 5
        anchorDimension = 2; % y-acceleration direction
    end
    if ~ismatrix(synMTS)
        error('The 1st input should be a matrix array\n');
    end
    
    sensordata = synMTS;
    
    switch samplingMethod
        case 'hybrid'
            [subsequences, subsequenceIdx] = ...
                        samplingatHybridPtsSynMTS(sensordata, anchorDimension,sel, seqlen, stride);

        case 'evenly'
            [subsequences, subsequenceIdx] = ...
                        samplingEvenly(sensordata, seqlen, stride);
        case 'randomly'
            [subsequences, subsequenceIdx] = ...
                        samplingRandomly(sensordata, seqlen, stride);
        otherwise
            error('Only support three kinds of sampling methods\n');
    end

    
end