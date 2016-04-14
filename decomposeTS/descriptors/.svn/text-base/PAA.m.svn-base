% piecewise aggregate approximation
% approximate a segment by piecewise aggregate approximation

% returned values: rep(representation); val_params(validated parameters,
% according to param)
function [rep, segLens, idx_seg, val_params] = PAA(subsequence, param)
    val_param = validatePAAparam(param);
    len = length(subsequence);
    
    switch val_param.priority
        case 'segNum'
            segNum = val_param.segNum;
            segLen = floor(len/segNum);
            
            if segLen < 1
                segNum = 1;
                segLen = len;
            end
        case 'segLen'
            segLen = val_param.segLen;
            segNum = floor(len/segLen);
            
            if segNum < 1
                segNum = 1;
                segLen = len;
            end        
    end   
    
    if segNum > length(subsequence)
        error('Inconsistency found between parameter setting and input sequences\n');
    end
    
    val_params.priority = val_param.priority;
    val_params.segNum = segNum;
    val_params.segLen = segLen;
    
    
    
    if segNum * segLen < len
        segLens = [segLen* ones(1, segNum-1) len - segLen*(segNum-1)];
	elseif segNum * segLen == len
        segLens = segLen * ones(1, segNum);
    else
        segLens = [segLen * ones(1, segNum-1)  segLen - (segLen*segNum - len)];
    end
    
    idx_seg = [0 cumsum(segLens)];
    
    segs = zeros(1,segNum);
    for i=1:segNum
        segs(i) = mean(subsequence(idx_seg(i)+1:idx_seg(i+1)));
    end    
    rep = segs;
end

