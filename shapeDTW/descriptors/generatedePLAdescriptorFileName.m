
function fileName = generatedePLAdescriptorFileName(param)
    
    if nargin == 0
        val_param = validatedePLAdescriptorparam;
    else
        val_param = validatedePLAdescriptorparam(param);
    end
    
    fileName = sprintf('dePLA-segNum-%d-fit-%s-xscale-%g', ...
                        val_param.segNum, val_param.fit, val_param.xscale);

end