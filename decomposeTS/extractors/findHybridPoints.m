% sample sequences:
% (1) first from feature points;
% (2) in the flat region, sample evenly

% input: sensordata, selectivity, stride (intervals between two consecutive samples
% output: index of hybrid points, including feature & flat points
%         marker, takes values from {-1,0,1}
%         -1: valley; 0: flat; 1: peak
% methods:
% (1) first find the feature points, specifically peaks and valleys
% (2) in the flat region, sample points evenly
function [idx, marker] = findHybridPoints(sensordata, sel, stride)
   
    nTimeStamps = length(sensordata);
    % find peaks
    sel = (max(sensordata(:)) - min(sensordata(:)))/sel;
    peakIdx = peakfinder(sensordata, sel, [], 1, false);
    % find valleys
    valleyIdx = peakfinder(sensordata, sel, [], -1, false);
    
    featureIdx = cat(1, peakIdx, valleyIdx);
    marker = [ones(numel(peakIdx),1); -ones(numel(valleyIdx),1)];
    [featureIdx, tidx] = sort(featureIdx, 'ascend');
    marker = marker(tidx);
    if isempty(featureIdx)
        featureIdx = [1; nTimeStamps];
        marker = [0;0];
    elseif featureIdx(1) ~= 1 && featureIdx(end) ~= nTimeStamps
        featureIdx = [1; featureIdx; nTimeStamps];
        marker = [0; marker; 0];
    elseif featureIdx(1) ~= 1 && featureIdx(end) == nTimeStamps
        featureIdx = [1; featureIdx];
        marker = [0; marker];
    elseif featureIdx(1) == 1 && featureIdx(end) ~= nTimeStamps
        featureIdx = [featureIdx; nTimeStamps];
        marker = [marker; 0];
    end        
    
    gaps = diff(featureIdx);
    idxBlank = find(gaps > stride);   
    flatIdx = [];
    
    for i=1:length(idxBlank)
        sidx = featureIdx(idxBlank(i));
        eidx = featureIdx(idxBlank(i) + 1);
        g_idx = sidx:stride:eidx;
        if  abs(g_idx(end) - eidx) <= stride 
            g_idx = g_idx(2:end-1);
        else
            g_idx = g_idx(2:end);
        end
        flatIdx = cat(1,flatIdx, g_idx');       
    end
    
    % make sure sub-sequences are arranged in the temporal order    
    idx = cat(1, featureIdx, flatIdx);
    marker = [marker; zeros(numel(flatIdx),1)];
    [idx, tidx] = sort(idx, 'ascend');
    marker = marker(tidx);
    
end
