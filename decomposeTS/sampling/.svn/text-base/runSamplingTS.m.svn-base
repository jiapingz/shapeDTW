% sampling TS from: hybrid, evenly, randomly
% different dimensions of TS needn't be synchronized, therefore, different
% dimensions can have different lengths.

function [subsequences, subsequenceIdx] = ...
                    runSamplingTS(TS, samplingMethod, sel, seqlen, stride)
                
    if ~iscell(TS)
        error('The 1st input should be a cell array\n');
    end
    
    ndims           = numel(TS);
    subsequences    = cell(1, ndims);
    subsequenceIdx  = cell(1, ndims);
    for i=1:ndims
        
        sensordata = TS{i};
        sensordata = sensordata(:);
        
        switch samplingMethod
            case 'hybrid'
                [subsequences{i}, subsequenceIdx{i}] = ...
                            samplingatHybridPts(sensordata, sel, seqlen, stride);

            case 'evenly'
                [subsequences{i}, subsequenceIdx{i}] = ...
                            samplingEvenly(sensordata, seqlen, stride);
            case 'randomly'
                [subsequences{i}, subsequenceIdx{i}] = ...
                            samplingRandomly(sensordata, seqlen, stride);
            otherwise
                error('Only support three kinds of sampling methods\n');
        end
    end 
    
end