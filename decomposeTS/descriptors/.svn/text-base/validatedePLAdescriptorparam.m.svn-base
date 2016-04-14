% validate derived PLA parameters
% difference from PLA:
% PLA: just approximation of PLA
% dePLA: derived features from PLA
function val_param = validatedePLAdescriptorparam(param)
     if nargin == 0 || ~isstruct(param)
         val_param = struct('segNum', 10, ...
                            'fit',    'regression', ...
                            'xscale', 1.0);
        return;
     end
     
     if ~isfield(param, 'xscale')
         val_param.xscale = 1.0;
     else
         val_param.xscale = param.xscale;
     end
     
     if ~isfield(param, 'segNum')
         val_param.segNum = 10;
     else
         val_param.segNum = param.segNum;
     end
     
     if ~isfield(param, 'fit')
         val_param.fit = 'regression';
     else
         val_param.fit = param.fit;
     end
       
     
end