
function fileName =  generateDWTdescriptorFileName(param)
    
    if nargin == 0
        val_param = validateDWTdescriptorparam;
    else
        val_param = validateDWTdescriptorparam(param);
    end
    
    fileName = sprintf('DWT-%s-n-%d-nLevels-%d', val_param.selection, ...
                                    val_param.n, val_param.numLevels);

    
end