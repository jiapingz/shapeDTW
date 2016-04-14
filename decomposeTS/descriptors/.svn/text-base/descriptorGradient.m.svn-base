function rep = descriptorGradient(subsequence, param)
    narginchk(1,2);
    
    if ~exist('param', 'var') || isempty(param)
        val_param = validateGradientdescriptorparam;
    else
        val_param = validateGradientdescriptorparam(param);
    end
    subsequence = subsequence(:);
    len = length(subsequence);
    switch val_param.gradMethod
        case 'centered'
            if len >= 3
                s1 = subsequence(1:len-2);
                s2 = subsequence(3:len);
                rep = (s2 - s1)/2;
                rep = rep';
            else
                rep = 0;
            end
        case 'uncentered'
            if len >= 2
                s1 = subsequence(1:len-1);
                s2 = subsequence(2:len);
                rep = s2 - s1;
                rep = rep';
            else
                rep = 0;
            end
        otherwise
            error('Only support two kinds of cases\n');
    end
    
    rep = rep / val_param.xscale;
    
end