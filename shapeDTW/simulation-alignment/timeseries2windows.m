function [nWindows, sIdx, eIdx] = timeseries2windows(ts_len, winsize, hopsize)
% convert a time series to localized windows
% features within each temporal window will be computed
%% inputs:
%           ts_len -- length of time series
%           winsize -- local temporal window size
%           hopsize -- overlap between two adjacent windows

%% outputs:
%           sIdx -- start index of each window
%           eIdx -- end index of each window

    increments = winsize - hopsize;
    nWins = round((ts_len-winsize)/increments) + 1;
    
    nWindows = 0;
    for i=(nWins-2):1:(nWins + 5)
        iLen = winsize + i*increments;
        if iLen <= ts_len && (iLen + increments) > ts_len
            nWindows = i+1;
            break;
        end        
    end
    sIdx = zeros(nWindows,1);
    eIdx = zeros(nWindows,1);
    for i=1:nWindows
        sIdx(i) = (i-1)*increments + 1;
        eIdx(i) = sIdx(i) + winsize -1;
    end
    
end