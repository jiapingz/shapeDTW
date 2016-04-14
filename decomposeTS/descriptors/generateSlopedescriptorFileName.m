function fileName =  generateSlopedescriptorFileName(param)
    
    if nargin == 0
        val_param = validateSlopedescriptorparam;
    else
        val_param = validateSlopedescriptorparam(param);
    end
    
    fileName = sprintf('Slope-segNum-%d-xscale-%g', val_param.segNum, ...
                                            val_param.xscale);
    
end