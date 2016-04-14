% methods:
% (1) first find the feature points, specifically peaks and valleys
% (2) in the flat region, sample points evenly

% difference from 'findHybridPoints.m'
% the former only supports one-dimensional time series
% this one supports multi-dimensional time series

function idx = findHybridPointsSynMTS(sensordata, sel, stride)
   
    narginchk(3,3);    
    [nTimeStamps, nDims] = size(sensordata);
    if nDims > nTimeStamps
        warning('Synchronized signals should be arranged column by column\n');
    end
    
    % (1) find feature point indices
    featureIdx = findFeaturePointsSynMTS(sensordata, sel);
    
    % (2) select points from flat regions
    if isempty(featureIdx)
        featureIdx = [1; nTimeStamps];
    elseif featureIdx(1) ~= 1 && featureIdx(end) ~= nTimeStamps
        featureIdx = [1; featureIdx; nTimeStamps];
    elseif featureIdx(1) ~= 1 && featureIdx(end) == nTimeStamps
        featureIdx = [1; featureIdx];
    elseif featureIdx(1) == 1 && featureIdx(end) ~= nTimeStamps
        featureIdx = [featureIdx; nTimeStamps];
    end        
    
    gaps = diff(featureIdx);
    idxBlank = find(gaps > stride);   
    flatIdx = [];
    
    for i=1:length(idxBlank)
        sidx = featureIdx(idxBlank(i));
        eidx = featureIdx(idxBlank(i) + 1);
        g_idx = sidx:stride:eidx;
        if  abs(g_idx(end) - eidx) < stride
            g_idx = g_idx(2:end-1);
        else
            g_idx = g_idx(2:end);
        end
        flatIdx = cat(1,flatIdx, g_idx');       
    end
    
    % make sure sub-sequences are arranged in the temporal order    
    idx = cat(1, featureIdx, flatIdx);
    idx = sort(idx);
     
end