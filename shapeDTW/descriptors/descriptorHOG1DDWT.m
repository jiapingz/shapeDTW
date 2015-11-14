% no normalization executed!!!
function rep = descriptorHOG1DDWT(subsequence, param)
    
    val_param = validateHOG1DDWTdescriptorparam(param);

    param_hog = val_param.HOG1D;
    param_dwt = val_param.DWT;
    
    rep_hog = descriptorHOG1D(subsequence, param_hog);
    rep_dwt = descriptorDWT(subsequence, param_dwt);
    
%     epsilon = 1.0e-6;
%     rep_hog = rep_hog/(sqrt(sum(rep_hog.*rep_hog))+epsilon);
%     rep_dwt = rep_dwt/(sqrt(sum(rep_dwt.*rep_dwt))+epsilon);
    
    rep = [rep_hog rep_dwt];
end