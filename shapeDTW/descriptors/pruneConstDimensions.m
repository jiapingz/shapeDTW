% pruning constant dimensions
% suitable for both univariate and multivariate time series descriptors
% the format of descriptors(nested cells) is specifically designed for this
% projects
function [pruned_descriptors, activeIdx] ...
                                        = pruneConstDimensions(descriptors)
    if isempty(descriptors) || ~iscell(descriptors) ...
                                    || ~iscell(descriptors{1})
        error('Wrong format of the input parameters\n');
    end
    epsilon    = 1.0e-2;
    nDims      = numel(descriptors{1});
    nInstances = numel(descriptors);
    pruned_descriptors = descriptors;
    activeIdx  = cell(1,nDims);
    for i=1:nDims
        i_descriptors = {};
        i_nInstances = [];
        for j=1:nInstances            
            i_nInstances  = cat(1, i_nInstances,  numel(descriptors{j}{i}));
            i_descriptors = cat(1, i_descriptors, descriptors{j}{i});            
        end
        i_descriptors = cell2mat(i_descriptors);
        
        variances = var(i_descriptors);
        bflag = variances > epsilon;
        i_descriptors = i_descriptors(:, bflag);
        i_descriptors = mat2cell(i_descriptors, i_nInstances);
        
        for j=1:nInstances
            pruned_descriptors{j}{i} = ...
                    mat2cell(i_descriptors{j},ones(size(i_descriptors{j},1),1));
        end         
        activeIdx{i} = bflag;
    end
    
end