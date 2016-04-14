
function [subsequences, subsequenceIdx] = samplingRandomly(sensordata, seqlen, stride)

    if ~ismatrix(sensordata) && ~isvector(sensordata)
        error('The 1st input parameter must be of matrix type\n');
    end

    %{
    if numel(sensordata) ~= max(size(sensordata))
        error('The 1st input should be 1-D time series\n');
    end
    sensordata = sensordata(:);
    %}
    
    len = size(sensordata,1);
    nSubsequences = round(len/stride);
    cnt = 0;
    
    mask = 1:seqlen;
    mask = mask - round(seqlen/2);
    
    rng('shuffle');
    subsequenceIdx = [];
    subsequences = {};
    while 1
        idx = randi(len);
        seqMask = mask + idx;
        sidx = seqMask(1); 
        eidx = seqMask(end);
        
        if sidx < 1 || eidx > len
            continue;
        end
        
        subsequenceIdx = cat(1, subsequenceIdx, idx);
        subsequences = cat(1, subsequences, sensordata(sidx:eidx,:));
        cnt = cnt + 1;
        if cnt == nSubsequences
            break;
        end
    end
    
end