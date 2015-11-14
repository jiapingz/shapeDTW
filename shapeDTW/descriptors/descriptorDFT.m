
function rep = descriptorDFT(subsequence, param)
    
    if ~isvector(subsequence)
        error('The 1st input should be a vector\n');
    end    
    val_param = validateDFTdescriptorparam(param);
        
    subsequence = subsequence(:);
    seqlen = length(subsequence);
    f = fft(subsequence);
    f = f';
    
    switch val_param.priority
        case 'numKept'
            numKept = val_param.numKept;
            n = min([numKept seqlen]);
            rep = f(1:n); 
        case 'ratioKept'
            ratioKept = val_param.ratioKept;
            n = round(ratioKept*seqlen);
            n = min([n seqlen]);
            rep = f(1:n);
        otherwise
            error('Check the parameter setting of the 2nd input\n');
    end
    
end