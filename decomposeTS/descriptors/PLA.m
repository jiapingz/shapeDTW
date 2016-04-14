% piecewise linear approximation
% RDP: iterative end-point fit algorithm
% fit the curve in a top-down manner, i.e. divisive
function rep = PLA(subsequence, param)
    val_param = validatePLARDPparam(param);
    
    nSeg = val_param.segNum;
    fitMethod = val_param.fit;
     
    subsequence = subsequence(:);
    [sp, idx, nNewSeg] = RDP(subsequence, nSeg);
    if nSeg <= 0
        error('Check the input parameters\n');
    end
    
    % make sure: nNewSeg can't be larger than nSeg
    if nNewSeg < nSeg
        paa_param = validatePAAparam;
        paa_param.priority  = 'segNum';
        paa_param.segNum    = val_param.segNum;
        [rep, ~, idx_seg, ~]   = PAA(subsequence, paa_param);
        idx = idx_seg(:);
        idx = [1; idx(2:end)];
        if strcmp(fitMethod, 'interpolation')
            rep = subsequence(idx);
            return;
        end
    end
    
    
    switch fitMethod
        case 'interpolation'
            rep = sp(:,2)';
        case 'regression'
            curve = zeros(nSeg,2);
            rep = zeros(1, nSeg+1);
            for i=1:nSeg
                x = idx(i):idx(i+1);
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