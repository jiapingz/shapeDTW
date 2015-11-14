function val_param = validateHOG1DDSPparam(param)
% descriptor HOG1D-DSP (domain size pooling)
   if nargin == 0 || isempty(param)
       val_param = struct('HOG1D', validateHOG1Dparam, ...
                          'DSP', validateDSPparam);
       return;
   end

   val_param = param;
   if ~isfield(val_param, 'HOG1D')
       val_param.HOG1D = validateHOG1Dparam;
   end
   
   if ~isfield(val_param, 'DSP')
       val_param.DSP = validateDSPparam;
   end

end