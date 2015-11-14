

function val_param = validateSlopePAAdescriptorparam(param)
    
    if nargin == 0 || ~isstruct(param) 
        val_param.Slope = validateSlopedescriptorparam;
        val_param.PAA = validatePAAdescriptorparam;
        return;
    end   
    
    
    if ~isfield(param, 'Slope')
        val_param_slope = validateSlopedescriptorparam;
    else
        param_slope = param.Slope;
        val_param_slope = validateSlopedescriptorparam(param_slope);
    end
    
    if ~isfield(param, 'PAA')
        val_param_paa = validatePAAdescriptorparam;
    else
        param_paa = param.PAA;
        val_param_paa = validatePAAdescriptorparam(param_paa);
    end
    
    val_param.Slope = val_param_slope;
    val_param.PAA = val_param_paa;
    
end