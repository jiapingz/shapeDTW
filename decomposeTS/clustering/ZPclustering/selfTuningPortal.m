function [partition, nClusters] =  selfTuningPortal(X, cluster_num_choices, ...
                                                            neighbor_num, weight)

 % 	neighbor_num = 7;         %% Number of neighbors to consider in local scaling
    narginchk(2,4);
    [nObservations, nDims] = size(X);
    if ~exist('weight', 'var') || isempty(weight)
        weight = ones(nObservations,1);
    end
    
    if ~exist('neighbor_num', 'var') || isempty(neighbor_num)
        neighbor_num = 7;
    end
    
 
    %% centralize and scale the data
    X = X - repmat(mean(X),size(X,1),1);
    X = X/max(max(abs(X)));

    %%%%%%%%%%%%%%%%% Build affinity matrices
    D = dist2(X,X);              %% Euclidean distance
    D = D./(weight*weight');
    [D_LS,A_LS,LS] = scale_dist(D,floor(neighbor_num)); %% Locally scaled affinity matrix
    clear D_LS; clear LS;
    
    %% Zero out diagonal
    ZERO_DIAG = ~eye(size(X,1));
 	A_LS = A_LS.*ZERO_DIAG;

    [clusts_RLS, rlsBestGroupIndex, qualityRLS] = cluster_rotate(A_LS,cluster_num_choices,0,1);
    fprintf('RLS qualities: %f \n', qualityRLS);    
    fprintf('RLS automatically chose best group index as %d (%d clusters)\n', rlsBestGroupIndex, length(clusts_RLS{rlsBestGroupIndex}));
    
    
%     clusters = cell(size(clusts_RLS));
%     for i=1:numel(clusts_RLS)
%         subclusters = cell(size(clusts_RLS{i}));
%         for j=1:numel(clusts_RLS{i})
%             subclusters{j} = X(clusts_RLS{i}{j},:);
%         end
%         clusters{i} = subclusters;
%     end
    nClusters = length(clusts_RLS{rlsBestGroupIndex}); 
    partition = zeros(size(X,1),1);
    
    for i=1:nClusters
        partition(clusts_RLS{rlsBestGroupIndex}{i},:) = i;
    end
    
    % to account for this:
    % some clusters have 0 members
    labels = unique(partition);
    nClusters = length(labels);
    for i=1:nClusters
        i_label = labels(i);
        flag = (partition == i_label);
        partition(flag) = i;
    end
    
end