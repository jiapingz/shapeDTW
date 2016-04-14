
function val_param = validateHOG1DPAAdescriptorparam(param)
    
    if nargin == 0 || ~isstruct(param)
        val_param.HOG1D = validateHOG1Dparam;
        val_param.PAA = validatePAAdescriptorparam;
        return;
    end

    param_hog = param.HOG1D;
    param_paa = param.PAA;
    val_param_hog = validateHOG1Dparam(param_hog);
    val_param_paa = validatePAAdescriptorparam(param_paa);
        
    val_param.HOG1D = val_param_hog;
    val_param.PAA = val_param_paa;
end