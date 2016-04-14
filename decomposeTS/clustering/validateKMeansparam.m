
function val_param = validateKMeansparam(param)
    if nargin == 0
        val_param = struct('nclusters', 20, ...
                           'EmptyAction', 'singleton', ...
                           'MaxIter', 100);
        return;
    end
    
    val_param = param;
    if ~isfield(val_param, 'ncluster')
        val_param.ncluster = 10;
    end
    
    if ~isfield(val_param, 'EmptyAction')
        val_param.emptyaction = 'singleton';
    end
    
    if ~isfield(val_param, 'MaxIter')
        val_param.MaxIter = 100;
    end
    
    
end