% setting of the parse tree of signals
function val_treeSetting = validateDecomposeTreeparam(treeSetting)

    if nargin == 0
        val_treeSetting = struct('depth', Inf, ...
                                  'minlen', 1, ...
                                  'splitModel', validateSplitModel);
        return;
    end
    
    val_treeSetting = treeSetting;
    if ~isfield(treeSetting, 'depth')
        val_treeSetting.depth = 5;
    end
    
    if ~isfield(treeSetting, 'minlen')
        val_treeSetting.minlen = 5;
    end
    
    if ~isfield(treeSetting, 'splitModel')
        val_treeSetting.splitModel = validateSplitModel;
    end

end