% difference from function 'findFeaturePoints.m'
% sensordata is a multi-dimensional time series
% input: sensordata (multi-dimensional time series, dimension is arranged
%        column by column
% (1) on each time series, find feature points independently;
% (2) combine all feature points, and remove those repetitive ones
% (3) output feature point indices

function featureIdx = findFeaturePointsSynMTS(sensordata, sel)
    narginchk(2,2);
    [~, nDims] = size(sensordata);
    indices = cell(nDims,1);
    
    for i=1:nDims
        i_sensordata = sensordata(:,i);
        i_sel = (max(i_sensordata(:)) - min(i_sensordata(:)))/sel;
        % find peaks
        peakIdx   = peakfinder(i_sensordata, i_sel, [], 1, false);
        % find valleys
        valleyIdx = peakfinder(i_sensordata, i_sel, [], -1, false);
        indices{i } = cat(1, peakIdx, valleyIdx);        
    end
    
    featureIdx = cell2mat(indices);
    featureIdx = unique(featureIdx);
    featureIdx = sort(featureIdx);
    
end