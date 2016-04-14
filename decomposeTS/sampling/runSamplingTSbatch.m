% running sampling for a dataset

function [subsequences, subsequenceIdx ] = ...
                    runSamplingTSbatch(TSbatch, samplingMethod, sel, seqlen, stride)
    
    if ~iscell(TSbatch)
        error('The 1st input should be a cell array\n');        
    end
    
    nSamples = numel(TSbatch);
    subsequenceIdx  = cell(nSamples,1);
    subsequences    = cell(nSamples,1);
    for i=1:nSamples
        TS = TSbatch{i};
        fprintf(1, 'Sampling from %d/%d time series, in way of %s ...\n', ...
                                            i, nSamples, samplingMethod);
        [subsequences{i}, subsequenceIdx{i}] = ...
             runSamplingTS(TS, samplingMethod, sel, seqlen, stride);
    end
    
end