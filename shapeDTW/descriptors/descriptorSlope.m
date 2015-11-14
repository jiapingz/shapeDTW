% first approximate the sequence by PAA, and then compute derivative for
% each segment

function rep = descriptorSlope(subsequence, param)
    
    subsequence = subsequence(:);
    val_param = validateSlopedescriptorparam(param);    
	PAAparam = struct('segNum', val_param.segNum, ...
                       'segLen', [], ...
                       'priority', 'segNum');
    xscale = val_param.xscale;
    slopeMethod = val_param.fit;
    if ~strcmp(slopeMethod, 'regression')
        error('Only support regression to fit the slope\n');
    end
    
    [~,~, idx_seg, ~] = PAA(subsequence, PAAparam);
    
    segNum = length(idx_seg)-1;
	slopes = zeros(1,segNum);
    for i=1:segNum
        interval = subsequence(idx_seg(i)+1:idx_seg(i+1));
        if length(interval) == 1
            slopes(i) = 0;
            continue;
        end
        x = 1:length(interval);
        x = xscale * x;    
        p = polyfit(x(:), interval,1);    
        slopes(i) = p(1); 
    end    
    rep = slopes;
    
end



