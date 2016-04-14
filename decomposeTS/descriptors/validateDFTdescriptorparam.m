
function val_param = validateDFTdescriptorparam(param)

    if nargin == 0 || ~isstruct(param)
        val_param = struct('numKept', 10, ...
                           'ratioKept', 0.5, ...
                           'priority', 'ratioKept');
        return;
    end
    
    if ~isfield(param, 'numKept')
        val_param.numKept = 10;
    elseif ~isempty(param.numKept) && param.numKept <= 0
        val_param.numKept = 10;
    else
        val_param.numKept= param.numKept;
    end
    
    if ~isfield(param, 'ratioKept')
        val_param.ratioKept = .5;
    elseif ~isempty(param.ratioKept) && param.ratioKept <= 0
        val_param.ratioKept = .5;
    else
        val_param.ratioKept = param.ratioKept;
    end
    
    if ~isfield(param, 'priority')
        val_param.priority = 'ratioKept';
    else
        val_param.priority = param.priority;
    end
    
    switch val_param.priority
        case 'numKept'
            if isempty(val_param.numKept) || val_param.numKept <= 0
                val_param.numKept = 10;
            end
        case 'ratioKept'
            if isempty(val_param.ratioKept) || val_param.ratioKept <= 0
                val_param.ratioKept = .5;
            end
        otherwise
            val_param.priority = 'ratioKept';
            if isempty(val_param.ratioKept) || val_param.ratioKept <= 0
                val_param.ratioKept = 0.5;
            end
    end



end