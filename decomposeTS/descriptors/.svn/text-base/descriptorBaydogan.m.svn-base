% represent subsequence with Baydogan's descriptor
% each interval is described by: mean, variance and slope
% descriptor of subsequence is a concatenation of: descriptors of intervals
% INPUT: scale is used to scale time axis
%        nIntervals: the number of intervals that subsequence is divied
%        into

function vec = descriptorBaydogan(subsequence, param)
    
    val_param   = validateBaydoganparam(param);
    xscale      = val_param.xscale;
    fitMethod   = val_param.fit;
    subsequence = subsequence(:);
    if ~strcmp(fitMethod, 'regression')
        error('Only support ''regression'' fitting method\n');
    end

    paa_param = validatePAAparam;
    paa_param.priority = 'segNum';
    paa_param.segNum   = val_param.segNum;
    [~, ~, idx_seg, ~] = PAA(subsequence, paa_param);
    idx = idx_seg(:);    
        
    nIntervals = length(idx_seg)-1;
    vec = [];
    for i=1:nIntervals
        sidx = idx(i)+1;
        eidx = idx(i+1);
        
        if eidx <= sidx
            %[me, v,slope];
            vec = cat(2, vec, [subsequence(sidx), 0, 0]);
            continue;
        end
        
        interval = subsequence(sidx:eidx);        
        vec = cat(2, vec, BaydoganFeatures(interval, xscale));           
        
    end
    
end