function val_param = validateSmoothCurveParam(param)
   
    if nargin == 0
        val_param = struct('len', 50, ...
                       'maxDerivative', 1, ...
                       'nNest', 10);
        return;
    end
    
    val_param = param;
    if ~isfield(val_param, 'len')
        val_param.len = 50;
    end
    
    if ~isfield(val_param, 'maxDerivative')
        val_param.maxDerivative = 1;
    end

    if ~isfield(val_param, 'nNest')
        val_param.nNest = 10;
    end

end