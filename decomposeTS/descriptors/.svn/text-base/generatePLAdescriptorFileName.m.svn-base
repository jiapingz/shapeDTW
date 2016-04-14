
function fileName = generatePLAdescriptorFileName(param)
    if nargin == 0
        val_param = validatePLAdescriptorparam;
    else
        val_param = validatePLAdescriptorparam(param);
    end
    
    fileName = sprintf('PLA-segNum-%d-fit-%s', val_param.segNum, ...
                                    val_param.fit);
end