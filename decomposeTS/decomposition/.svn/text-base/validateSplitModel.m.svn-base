
function val_model = validateSplitModel(model)

    if nargin == 0
        val_model = struct('criterion',     'entropy', ...
                           'nclasses',      20, ...
                           'dissimilarity', []);
                       
        % criterion: entropy, misclassification,
        %            gini, spreadness
        return;
    end
    
    val_model = model;
    if ~isfield(model, 'criterion')
        val_model.criterion = 'entropy';
    end
    
    if ~isfield(model, 'dissimilarity')
        val_model.dissimilarity = [];
    end
    
    if ~isfield(model, 'nclasses')
        model.nclasses = 20;
    end
    
    return;

end