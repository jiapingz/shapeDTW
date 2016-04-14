% no normalization executed!!!
function rep = descriptorHOG1DPAA(subsequence, param)
    
    val_param = validateHOG1DPAAdescriptorparam(param);

    param_hog = val_param.HOG1D;
    param_paa = val_param.PAA;
    
    rep_hog = descriptorHOG1D(subsequence, param_hog);
    rep_paa = descriptorPAA(subsequence, param_paa);
    
%     epsilon = 1.0e-6;
%     rep_hog = rep_hog/(sqrt(sum(rep_hog.*rep_hog))+epsilon);
%     rep_paa = rep_paa/(sqrt(sum(rep_paa.*rep_paa))+epsilon);
    
    rep = [rep_hog rep_paa];
end