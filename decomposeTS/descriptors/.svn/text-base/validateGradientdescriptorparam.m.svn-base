
function val_param = validateGradientdescriptorparam(param)
    if nargin == 0
        val_param = struct('gradMethod', 'uncentered', ...
                           'xscale', 0.1);
        return;
    end
    
    val_param = param;
    if ~isfield(val_param, 'uncentered')
        val_param.gradMethod = 'uncentered';
    end
    
    if ~isfield(val_param, 'xscale')
        val_param.xscale = 0.1;
    end
    
end