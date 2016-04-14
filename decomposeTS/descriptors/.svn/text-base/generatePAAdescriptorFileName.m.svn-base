
function fileName =  generatePAAdescriptorFileName(param)
    
    if nargin == 0
        val_param = validatePAAdescriptorparam;
    else
        val_param = validatePAAdescriptorparam(param);
    end
    
    switch val_param.priority
        case 'segNum'
            fileName = sprintf('PAA-segNum-%d', val_param.segNum);
        case 'segLen'
            fileName = sprintf('PAA-segLen-%d', val_param.segLen);
    end
    
end