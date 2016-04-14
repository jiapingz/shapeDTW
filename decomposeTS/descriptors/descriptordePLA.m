% piecewise linear approximation
% RDP: iterative end-point fit algorithm
% fit the curve in a top-down manner, i.e. divisive
function rep = descriptordePLA(subsequence, param)

    val_param = validatedePLAdescriptorparam(param);    
    nSeg        = val_param.segNum;
    fitMethod   = val_param.fit;
    xscale      = val_param.xscale;
    
    %{
    if ~strcmp(fitMethod, 'regression')
        error('Only support regression, doesn''ts support interpolation yet\n');
    end
    %} 
    
    subsequence = subsequence(:);
    [~, idx, nNewSeg] = RDP(subsequence, nSeg);
    if nSeg <= 0
        error('Check the input parameters\n');
    end
    
    % make sure: nNewSeg can't be larger than nSeg
    if nNewSeg < nSeg
        paa_param = validatePAAparam;
        paa_param.priority = 'segNum';
        paa_param.segNum   = val_param.segNum;
        [~, ~, idx_seg, ~] = PAA(subsequence, paa_param);
        idx = idx_seg(:);
        idx= [1; idx(2:end)];
    end
    
    me = zeros(1, nSeg);
    slopes = zeros(1,nSeg);
    segLens = zeros(1,nSeg);

    switch fitMethod
        case 'regression'
            for i=1:nSeg
                if idx(i+1)-1 > idx(i)
                    x = idx(i):idx(i+1)-1;
                    y = subsequence(x);
                    p = polyfit(x(:)*xscale, y(:),1);    
        %             curve(i,1) = p(1)*x(1) + p(2);
        %             curve(i,2) = p(1)*x(end) + p(2);
                    slopes(i)  = p(1);
                    segLens(i) = idx(i+1) - idx(i);
                    me(i) = mean(subsequence(idx(i):idx(i+1)-1));
                else
                    me(i) = subsequence(idx(i));
                    segLens(i) = 1;
                    x = idx(i):idx(i)+1;
                    y = subsequence(x);
                    p = polyfit(x(:)*xscale, y(:),1);
                    slopes(i) = p(1);
                end
            end
        case 'interpolation'
            x = idx;
            y = subsequence(idx);
            
            for i=1:nSeg
                me(i) = (y(i) + y(i+1))/2;
                slopes(i) = (y(i+1) - y(i))/xscale;
                segLens(i) = x(i+1) - x(i);
            end

        otherwise
            
    end
    
%     rep = reshape([me; slopes; segLens], 1, 3*nSeg);
    rep = reshape([me; slopes], 1, 2*nSeg);
    
end