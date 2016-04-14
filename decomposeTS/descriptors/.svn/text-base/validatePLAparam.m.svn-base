% validate parameters for piecewise linear approximation
% it has the same parameter setting as PLA-RDP parameter settings

function val_param = validatePLAparam(param)

    if nargin == 0 || isempty(param)
        val_param.segNum = 10;
        val_param.fit    = 'regression';
        return;
    end    
    val_param = validatePLARDPparam(param);
    
end