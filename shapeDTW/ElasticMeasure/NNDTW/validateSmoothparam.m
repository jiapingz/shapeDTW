
function val_param = validateSmoothparam(param)
    if nargin == 0 || ~exist('param', 'var')
        val_param = struct('span', 5, ...
                           'method', 'moving');
        return;
    end
    
    val_param = param;
    if ~isfield(val_param, 'span')
        val_param.span = 5;
    end
    
    if ~isfield(val_param, 'moving')
        val_param.method = 'moving';
    end
end