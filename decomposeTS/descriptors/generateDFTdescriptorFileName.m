
function fileName =  generateDFTdescriptorFileName(param)
    
    if nargin == 0
        val_param = validateDFTdescriptorparam;
    else
        val_param = validateDFTdescriptorparam(param);
    end
    
    switch val_param.priority
        case 'ratioKept'
            fileName = sprintf('DFT-ratioKept-%g', val_param.ratioKept);
        case 'numKept'
            fileName = sprintf('PAA-numKept-%d', val_param.numKept);
    end
    
end