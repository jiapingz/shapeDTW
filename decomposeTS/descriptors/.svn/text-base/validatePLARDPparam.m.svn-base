
function val_param = validatePLARDPparam(param)
    if nargin == 0 || isempty(param)
        val_param.segNum = 10;
        val_param.fit = 'regression';
        return;
    end
    
    if ~isfield(param, 'segNum')
        val_param.segNum = 10;
    else
        val_param.segNum = param.segNum;
    end
    
    if ~isfield(param, 'fit')
        val_param.fit = 'regression';
    else
        val_param.fit = param.fit;
    end
    
end