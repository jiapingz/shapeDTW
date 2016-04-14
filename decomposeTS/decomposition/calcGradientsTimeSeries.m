% calculate gradients of TS
% step 1: sampling, so that time series is represented as a sequence of
% subsequences
% step 2: compute biased gradients: [-1 1]
% step 3: plot gradients

function [gradients, subsequencesIdx] = ...
                            calcGradientsTimeSeries(TS, samplingSetting)
    % 1.sampling
    samplingSetting = validateSamplingSetting(samplingSetting);
    sel = samplingSetting.param.sel;
    stride = samplingSetting.param.stride;
    seqlen = samplingSetting.param.seqlen;
    samplingMethod = samplingSetting.method;
    
    sensordata = TS(:);
	switch samplingMethod
        case 'hybrid'
            [subsequences, subsequencesIdx, markers] = ...
                        samplingatHybridPts(sensordata, sel, seqlen, stride);
        case 'evenly'
            [subsequences, subsequencesIdx] = ...
                        samplingEvenly(sensordata, seqlen, stride);
            markers = zeros(numel(subsequencesIdx),1);
        case 'randomly'
            [subsequences, subsequencesIdx] = ...
                        samplingRandomly(sensordata, seqlen, stride);
            markers = zeros(numel(subsequencesIdx),1);
        otherwise
            error('Only support three kinds of sampling methods\n');
    end
    
    nSubsequences = numel(subsequences);
    gradients = zeros(1, nSubsequences);
    
    % 2.1 peaks
    IdxPeaks = find(markers ~= -1);
    subsequencesPeaks = subsequences(IdxPeaks);
    for i=1:numel(IdxPeaks)-1
        if markers(IdxPeaks(i)) == 0
            continue;
        end
        r = subsequencesPeaks{i};
        t = subsequencesPeaks{i+1};
        d = dtw_c(r,t);
%         d = norm(r-t,2);
        gradients(IdxPeaks(i)) = d;
    end
    if IdxPeaks(end) == 1
        gradients(IdxPeaks(end)) = d;
    end
    
    % 2.2 valleys
    IdxValleys = find(markers ~= 1);
    subsequencesValleys = subsequences(IdxValleys);
    for i=1:numel(IdxValleys)-1
        if markers(IdxValleys(i)) == 0
            continue;
        end
        r = subsequencesValleys{i};
        t = subsequencesValleys{i+1};
        d = dtw_c(r,t);
%         d = norm(r-t,2);
        gradients(IdxValleys(i)) = d;
    end
    if IdxValleys(end) == -1
        gradients(IdxValleys(end)) = d;
    end
    
    % 2.3 flat points
    for i=1:numel(markers)-1
        if markers(i) ~= 0
            continue;
        end
        r = subsequences{i};
        t = subsequences{i+1};
        d = dtw_c(r,t);
%         d = norm(r-t,2);
        gradients(i) = d;
    end
    if markers(end) == 0
        gradients(end) = d;
    end
    
    if nargout == 0
        gMin = min(gradients);
        gMax = max(gradients);
        nGradients = (gradients - gMin)/gMax;
        
        len = numel(TS);
        span = (max(TS) - min(TS));
        gap = span/2;
        
        nGradients = nGradients * span;
        figure; 
        plot(subsequencesIdx, nGradients, 'b', 'linewidth',2);
        hold on;
        plot(TS - min(TS) + 1.2*span, 'r');
        xlim([0 len+1]);
        ylim([0 2.2*span]);
    end


end