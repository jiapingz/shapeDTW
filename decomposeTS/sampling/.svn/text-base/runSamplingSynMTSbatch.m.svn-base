% running sampling for a dataset, the dataset has to be MTS

function [subsequences, subsequenceIdx ] = ...
                    runSamplingSynMTSbatch(synMTSbatch, samplingMethod, sel, seqlen, stride, anchorDimension)
    
    error(nargchk(5,6, nargin));
    if nargin < 5
        anchorDimension = 2;
    end
    
    if ~iscell(synMTSbatch)
        error('The 1st input should be a cell array\n');        
    end
    
    nSamples = numel(synMTSbatch);
    subsequenceIdx  = cell(nSamples,1);
    subsequences    = cell(nSamples,1);
    for i=1:nSamples
        MTS = synMTSbatch{i};
        fprintf(1, 'Sampling from %d/%d time series, in way of %s\n', ...
                                            i, nSamples, samplingMethod);
        [subsequences{i}, subsequenceIdx{i}] = ...
             runSamplingSynMTS(MTS, samplingMethod, sel, seqlen, stride, anchorDimension);
    end
    
end