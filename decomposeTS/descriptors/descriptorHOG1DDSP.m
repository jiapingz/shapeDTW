function rep = descriptorHOG1DDSP(sequence, param)

    narginchk(1,2);
    if ~isvector(sequence)
        error('Only support univariate time series\n');
    end
    
    if ~exist('param', 'var') || isempty(param)
        param = validateHOG1DDSPparam;
    end
    
    param = validateHOG1DDSPparam(param);
    
    hogParam = param.HOG1D;
    dspParam = param.DSP;
    
    rScales = dspParam.rScales;
    nScales = dspParam.nScales;
    pooling = dspParam.pooling;
    
    scales = linspace(rScales(1), rScales(2), nScales);
    
    len = length(sequence);
    rep = [];
    
    for s=1:nScales
        slen = round(scales(s) * len);
        smask = (1:slen) - round(slen/2) + round(len/2);
        
        smask(1) = max(1, smask(1));
        smask(end) = min(len, smask(end));
        
        s_sequence = sequence(smask(1):smask(end));
        s_sequence = stretchTS2(s_sequence, len);
        
        rep = cat(1, rep, descriptorHOG1D(s_sequence, hogParam));
        
    end
    
    switch pooling
        case 'ave'
            rep = mean(rep,1);
        case 'sum'
            rep = sum(rep,1);
        otherwise
            error('Only support two pooling ways\n')
    end
    
end