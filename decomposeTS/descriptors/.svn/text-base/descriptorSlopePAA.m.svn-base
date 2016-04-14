% a combination of slope and PAA descriptors
% MKL may solve the problem of different combination weights!!!

function rep = descriptorSlopePAA(subsequence, param)
    
    subsequence = subsequence(:);
    val_param = validateSlopePAAdescriptorparam(param);    
    
    param_paa = val_param.PAA;
    param_slope = val_param.Slope;
    
	rep_slope = descriptorSlope(subsequence, param_slope);
    rep_paa = descriptorPAA(subsequence, param_paa);
    
    rep = [rep_slope rep_paa];
    
end
