% split into 'nfolders', for later-on cross validation
% input: labels, should be integers
%        nfolders, the # of folders to be splitted into
% output: partitions, a logical partitions 

function partitions = CVsplit2folders(labels, nfolders)
    nsamples = numel(labels);
    unique_labels = unique(labels);
    nclasses = numel(unique_labels);
    folders = cell(nfolders,1);
    
    for i=1:nclasses
        i_label = unique_labels(i);
        i_idx = labels == i_label;
        i_idx = find(i_idx);
        i_idx = i_idx(:);
        n_idx = numel(i_idx);
        rng('shuffle');
        rorder = randperm(n_idx);
        i_idx = i_idx(rorder);    
        stride = max(1,round(n_idx/nfolders));
        
        cnt = 0;
        sidx = 1;
        while sidx <= n_idx  && cnt < nfolders          
            eidx = min(sidx + stride - 1, n_idx);                        
            cnt = cnt + 1;
            if cnt == nfolders
                eidx = n_idx;
            end
            folders{cnt} = cat(1,folders{cnt}, i_idx(sidx:eidx));            
            sidx = sidx + stride;
        end        
    end
    
    partitions = [];
    
    for i=1:nfolders
        t = folders{i};
        if isempty(t)
            continue;
        end
        partition = zeros(nsamples,1);
        partition(t) = 1;
        partitions = cat(2,partitions, partition);
    end
    
    partitions = logical(partitions);
    
end