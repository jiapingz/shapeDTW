function rep = descriptorGradSelf(subsequence, param)
    
    val_param = validateGradSelfdescriptorparam(param);

    param_grad = val_param.Grad;
    
    
    rep_grad = descriptorGradient(subsequence, param_grad);
    rep_self = self(subsequence);
    
    rep = [rep_grad rep_self];
end