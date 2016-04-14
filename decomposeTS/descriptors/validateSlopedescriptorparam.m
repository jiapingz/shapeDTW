
% validate Baydogan's parameter

function val_param = validateSlopedescriptorparam(param)

    if nargin == 0 || ~isstruct(param) 
        val_param.xscale = 0.1;
        val_param.segNum = 10;
        val_param.fit = 'regression';
        return;
    end
    
    if ~isfield(param, 'xscale')
        val_param.xscale = 0.1;
    else
        val_param.xscale = param.xscale;
    end
        
    if ~isfield(param, 'segNum')
        val_param.segNum = 10;
    else
        val_param.segNum = param.segNum;
    end
    
    if ~isfield(param, 'fit')
        val_param.fit    = 'regression';
    else
        val_param.fit    = param.fit;
    end
    
end