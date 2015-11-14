function val_param = validateStretchingParam(param)

    if nargin == 0
        val_param = struct('percentage', 0.15, ...
                           'amount', 2);
        return;
    end

    val_param = param;
    if ~isfield(val_param, 'percentage')
        val_param.percentage = 0.15;
    end
    
    if ~isfield(val_param, 'amount')
        val_param.amount = 2;
    end


end