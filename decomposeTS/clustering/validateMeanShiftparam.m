
function val_param = validateMeanShiftparam(param)
    if nargin == 0
        val_param = struct('bandWidth', 10);
        return;
    end
    
    val_param = param;    
    
    if ~isfield(val_param, 'bandWidth')
        val_param.sigma = 10;
    end
    
    
end