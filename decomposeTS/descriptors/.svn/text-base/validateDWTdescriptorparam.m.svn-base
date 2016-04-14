% now we would fix the basis to be Haar
% so the only variable here is the number of levels

function val_param = validateDWTdescriptorparam(param)
    if nargin == 0 || ~isstruct(param)
        val_param = struct('numLevels', 2, ...
                           'selection', 'Haar', ...
                           'n', 2);
        return;
    end
    
    val_param = param;
    
    if ~isfield(param, 'numLevels')
        val_param.numLevels = 2;
    end
    
    if ~isfield(param, 'selection');
        val_param.selection = 'Haar';
    end
    
    if ~isfield(param, 'n')
        val_param.n = 2;
    end
    
end