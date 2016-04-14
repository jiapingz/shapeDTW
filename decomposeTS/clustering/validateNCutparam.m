
function val_param =  validateNCutparam(param)
    if nargin == 0
        val_param = struct('nclusters', 5, ...
                           'sigma', []);
        return;
    end
    
    val_param = param;
    if ~isfield(val_param, 'nclusters')
        val_param.nclusters = 5;
    end
    
    if ~isfield(val_param, 'sigma')
        val_param.sigma = [];
    end
end