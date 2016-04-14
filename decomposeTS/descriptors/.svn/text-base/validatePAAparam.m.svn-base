% validate parameters of piecewise aggregate approximation
function val_param = validatePAAparam(param)
    
    if nargin == 0 || ~isstruct(param)
        val_param = struct('segNum', 10, ...
                           'segLen', [], ...
                           'priority', 'segNum');
        return;
    end
    
    if ~isfield(param, 'segNum')
        val_param.segNum = 10;
    elseif ~isempty(param.segNum) && param.segNum <= 0
        val_param.segNum = 10;
    else
        val_param.segNum = param.segNum;
    end
    
    if ~isfield(param, 'segLen')
        val_param.segLen = 5;
    elseif ~isempty(param.segLen) && param.segLen <= 0
        val_param.segLen = 5;
    else
        val_param.segLen = param.segLen;
    end
    
    if ~isfield(param, 'priority')
        val_param.priority = 'segNum';
    else
        val_param.priority = param.priority;
    end
    
    switch val_param.priority
        case 'segNum'
            if isempty(val_param.segNum) || val_param.segNum <= 0
                val_param.segNum = 10;
            end
        case 'segLen'
            if isempty(val_param.segLen) || val_param.segLen <= 0
                val_param.segLen = 5;
            end
        otherwise
            val_param.priority = 'segNum';
            if isempty(val_param.segNum) || val_param.segNum <= 0
                val_param.segNum = 10;
            end
    end
	
        
end