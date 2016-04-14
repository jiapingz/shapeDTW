% generate descriptor filename for HOG1D-PAA descriptor
function fileName = generateHOG1DPAAFileName(param)
    if nargin == 0
        val_param = validateHOG1DPAAdescriptorparam;
    else
        val_param = validateHOG1DPAAdescriptorparam(param); 
    end
    
    if ~isfield(val_param, 'HOG1D')
        param_hog = validateHOG1Dparam;
    else
        param_hog = val_param.HOG1D;
    end
    
    if ~isfield(val_param, 'PAA')
        param_paa = validatePAAdescriptorparam;
    else
        param_paa = val_param.PAA;
    end
        
    fileName_hog = generateHOG1DFileName(param_hog);
    fileName_paa = generatePAAdescriptorFileName(param_paa);
    
    fileName = sprintf('HOG1DPAA-%s-%s', fileName_hog, fileName_paa);
end