function val_param = validateDSPparam(param)
% validate domain size pooling (DSP) parameters
    if nargin == 0
        val_param = struct('nScales', 3, ...    % number of scales
                           'rScales', [0.5 1], ... % range of scales
                           'pooling', 'ave');    % 'sum' or 'ave' pooling 
                                                 % 'sum' or 'ave' pooling
        return;
    end
    
    val_param = param;
    if ~isfield(val_param, 'nScales')
        val_param.nScales = 3;
    end
    
    if ~isfield(val_param, 'rScales')
        val_param.rScales = [0.5 1];
    end
    
    if ~isfield(val_param, 'pooling')
        val_param.pooling = 'ave';
    end
    
end