function val_param = validateGradSelfdescriptorparam(param)
    
    if nargin == 0 || ~isstruct(param)
        val_param.Grad = validateGradientdescriptorparam;
        val_param.Self = [];
        return;
    end

    val_param = param;
    if ~isfield(val_param, 'Grad')
        val_param.Grad = validateGradientdescriptorparam;
    end
    
    val_param.Self = [];
end