
function fileName = generateBaydoganFileName(param)
    if nargin == 0
        val_param = validateBaydoganparam;
    else
        val_param = validateBaydoganparam(param);
    end
    
    fileName = sprintf('Baydogan-segNum-%d-xscale-%g', val_param.segNum, ...
                                            val_param.xscale);
    
end