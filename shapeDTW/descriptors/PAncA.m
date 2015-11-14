% piecewise anchor points approximation
% subsequence should be a 1D vector
% make sure the returned # of segments are in consistent with the input
% parameters

%% NOTE: since there is some problem to evaluate importances of 
% key points, now this function can't be used 

function PAncA(subsequence, param)
    
    val_param = validatePAncAparam(param);
    len = numel(subsequence);    
    sel = 1000; % set sel bigger enought, such that all points with left/right 
                % derivatives changing signs are selected
    [idx, significances] = findFeaturePoints(subsequence, sel);
    
    % make sure end points are included
    idx           = idx(:); 
    significances = significances(:);
    if isempty(find(idx == 1))
        idx = [1; idx];
        significances = [max(significances); significances];
    end
    if isempty(find(idx == len))
        idx = [idx; len];
        significances = [significances; max(significances)];
    end
    
    [sorted_significances, tidx] = sort(significances, 'descend');
    sorted_idx  = idx(tidx);
    nKeyPts     = length(sorted_idx);
    fitMethod   = val_param.fit;
    nSeg        = val_param.segNum;
    
    if nKeyPts >= nSeg + 1
        idx_anchor = sorted_idx(1:nSeg+1);
        sig_anchor = sorted_significances(1:nSeg+1);
        [idx_anchor, tidx] = sort(idx_anchor, 'ascend');
        sig_anchor = sig_anchor(tidx);
    else
        paa_param = validatePAAparam;
        paa_param.priority = 'segNum';
        paa_param.segNum = val_param.segNum;
        [rep, idx_seg, ~] = PAA(subsequences, paa_param);
        idx_anchor = idx_seg(:);
        idx_anchor = [1; idx_anchor(2:end)];
    end
    
    sp = subsequence(idx_anchor);
        
    switch fitMethod
        case 'interpolation'
            rep = sp';
        case 'regression'
            curve = zeros(nSeg,2);
            rep = zeros(1, nSeg+1);
            for i=1:nSeg
                x = idx_anchor(i):idx_anchor(i+1);
                y = subsequence(x);
                p = polyfit(x(:), y(:),1);    
                curve(i,1) = p(1)*x(1) + p(2);
                curve(i,2) = p(1)*x(end) + p(2);
                               
            end
            tmp = reshape(curve', 1, numel(curve));
            rep(1) = tmp(1); rep(end) = tmp(end);
            if nSeg > 1
                tmp = tmp(2:end-1);
                tmp = mean(reshape(tmp, 2, nSeg-1));
                rep(2:end-1) = tmp;            
            end
        otherwise
    end
    
  
    
end