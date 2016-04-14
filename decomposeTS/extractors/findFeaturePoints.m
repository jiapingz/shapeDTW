% sample sequences centering on feature points: specifically valley and
% peak points

% input: sensordata and selectivity
% sel: the larger it is, the more selective it is.
% output: index of feature points

function [idx, marker, significances] = findFeaturePoints(sensordata, sel)
   
    sel = (max(sensordata(:)) - min(sensordata(:)))/sel;
    % find peaks
    [peakIdx, ~, PeakSig] = peakfinder(sensordata, sel, [], 1, false);
    % find valleys
    [valleyIdx, ~, valleySig] = peakfinder(sensordata, sel, [], -1, false);
    
    featureIdx = cat(1, peakIdx, valleyIdx);
    marker = [ones(numel(peakIdx),1); -ones(numel(valleyIdx),1)];
    sig = cat(1, PeakSig, valleySig);
    [idx, tidx] = sort(featureIdx, 'ascend');
    significances = sig(tidx);
    marker = marker(tidx);
    
    % plot
    if nargout == 0
        figure;
        mag = sensordata(idx);
        plot(sensordata, 'b', 'linewidth',2);
        hold on;
        plot(idx, mag , 'ro', 'MarkerSize', 10, 'linewidth', 3);
        set(gca, 'ylim', [min(sensordata)  max(sensordata)]);
        set(gca, 'xlim', [0 length(sensordata) + 1]);
%         set(gca, 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', []);
%         set(gca, 'xcolor', [1 1 1], 'ycolor', [1 1 1]);
    end
    
end