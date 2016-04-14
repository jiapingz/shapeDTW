
function val_param = validateGraclusparam(param)
    if nargin == 0
        val_param = struct('nclusters', 5, ...
                           'sigma', [], ...
                           'cutType', 0); % 0 for NCut & 1 for RAssoc
        return;
    end
    
    val_param = param;
    if ~isfield(val_param, 'nclusters')
        val_param.nclusters = 5;
    end
    
    if ~isfield(val_param, 'sigma')
        val_param.sigma = [];
    end
    
    if ~isfield(val_param, 'cutType')
        val_param.cutType = 0;
    end
    
    
end