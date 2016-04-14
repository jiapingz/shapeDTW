% keep consistent with the convention,
% each row of X is an observation,
% each column of X is an attribute

function partition = ncutPortal(X, nclusters, scale_sig)

    data = X';
    if ~exist('scale_sig', 'var') || isempty(scale_sig)
        [W,Dist] = compute_relation(data);
    else
        [W,Dist] = compute_relation(data,scale_sig);
    end

    % clustering graph in    
    tic;
    [NcutDiscrete,NcutEigenvectors,NcutEigenvalues] = ncutW(W, nclusters);
    disp(['The computation took ' num2str(toc) ' seconds']);    
    clear NcutEigenvalues NcutEigenvectors;
    
%     clusters = cell(1, nclusters);       
    partition = zeros(size(X,1),1);
    for j=1:nclusters,
        id = find(NcutDiscrete(:,j));        
%         clusters{j} = X(id,:);
        partition(id) = j;
    end
    
end