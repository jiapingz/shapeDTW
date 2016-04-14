
function val_param = validateHOG1DDWTdescriptorparam(param)
    
    if nargin == 0 || ~isstruct(param)
        val_param.HOG1D = validateHOG1Dparam;
        val_param.DWT = validateDWTdescriptorparam;
        return;
    end

    param_hog = param.HOG1D;
    param_dwt = param.DWT;
    val_param_hog = validateHOG1Dparam(param_hog);
    val_param_dwt = validateDWTdescriptorparam(param_dwt);
        
    val_param.HOG1D = val_param_hog;
    val_param.DWT = val_param_dwt;
end