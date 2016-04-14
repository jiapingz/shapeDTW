% validate Baydogan's parameter

function val_param = validateWindauparam(param)

    if nargin == 0 || ~isstruct(param) 
        val_param.bYDirection = false;
        return;
    end
    
    if ~isfield(param, 'bYDirection')
        val_param.bYDirection = false;
    else
        val_param.bYDirection = param.bYDirection;
    end
        
end