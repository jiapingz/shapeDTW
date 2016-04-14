
function val_param = validateSelfTuningparam(param)
    if nargin == 0
        val_param = struct('nClusters', 2:10, ...  % # of candiate clusters
                       'nNeighbors', 7, ...        % # of neighborhood points
                       'weights', []);             % weights of each point
        return;
    end
    
    val_param = param;
    if ~isfield(val_param, 'nClusters')
        val_param.nclusters = 2:10;
    end
    
    if ~isfield(val_param, 'nNeighbors')
        val_param.nNeighbors = 7;
    end
    
    if ~isfield(val_param, 'weights')
        val_param.weights = [];
    end
end