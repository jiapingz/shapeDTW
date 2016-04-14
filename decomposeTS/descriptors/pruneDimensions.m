% pruning constant dimensions
% suitable for both univariate and multivariate time series descriptors
% the format of descriptors(nested cells) is specifically designed for this
% projects
function pruned_descriptors = pruneDimensions(descriptors, activeIdx)

    if isempty(descriptors) || ~iscell(descriptors) ...
                                    || ~iscell(descriptors{1})
        error('Wrong format of the input parameters\n');
    end
    
    nDims      = numel(descriptors{1});
    if nDims ~= numel(activeIdx)
        error('Inconsistency between two inputs\n');
    end
    nInstances = numel(descriptors);
    pruned_descriptors = descriptors;
    
    for i=1:nDims
        i_descriptors = {};
        i_nInstances = [];
        for j=1:nInstances            
            i_nInstances  = cat(1, i_nInstances,  numel(descriptors{j}{i}));
            i_descriptors = cat(1, i_descriptors, descriptors{j}{i});            
        end
        i_descriptors = cell2mat(i_descriptors);
        
        bflag = activeIdx{i};
        i_descriptors = i_descriptors(:, bflag);
        i_descriptors = mat2cell(i_descriptors, i_nInstances);
        
        for j=1:nInstances
            pruned_descriptors{j}{i} = ...
                    mat2cell(i_descriptors{j},ones(size(i_descriptors{j},1),1));
        end         
    end
    
end