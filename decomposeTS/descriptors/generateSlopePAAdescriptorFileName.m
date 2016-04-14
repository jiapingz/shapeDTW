
function fileName =  generateSlopePAAdescriptorFileName(param)
    
    if nargin == 0
        val_param = validateSlopePAAdescriptorparam;
    else
        val_param = validateSlopePAAdescriptorparam(param); 
    end
    
    if ~isfield(val_param, 'Slope')
        param_slope = validateSlopedescriptorparam;
    else
        param_slope = val_param.Slope;
    end
    
    if ~isfield(val_param, 'PAA')
        param_paa = validatePAAdescriptorparam;
    else
        param_paa = val_param.PAA;
    end
    
    fileName_slope = generateSlopedescriptorFileName(param_slope);
    fileName_paa = generatePAAdescriptorFileName(param_paa);
    
    fileName = sprintf('SlopePAA-%s-%s', fileName_slope, fileName_paa);
    
end