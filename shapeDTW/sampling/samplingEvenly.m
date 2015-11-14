
% when doing evenly sampling, we choose a random start point, specifically
% randomStartPt = randi(stride);
function [subsequences, subsequenceIdx] = samplingEvenly(sensordata, seqlen, stride)

    if ~ismatrix(sensordata) && ~isvector(sensordata)
        error('The 1st input parameter must be of matrix type\n');
    end

    %{
    if numel(sensordata) ~= max(size(sensordata))
        error('The 1st input should be 1-D time series\n');
    end    
    sensordata = sensordata(:);
    %}
    
    subsequences = {}; 
    subsequenceIdx = [];
    len = size(sensordata,1);
    rng('shuffle');
    tstart = randi(stride);
    tend = tstart + seqlen - 1;
    while tstart >=1 && tstart <= len && ...
            tend >=1 && tend <= len
        subsequences = cat(1, subsequences, sensordata(tstart:tend,:));
        subsequenceIdx = cat(1,subsequenceIdx, round((tend-tstart+1)/2));
        tstart = tstart + stride;
        tend = tend + stride;
    end
    
    
end