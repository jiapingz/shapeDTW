% instead of decomposing matrices, graclus solves an optimization problem,
% which is more scalable to massive graph

% X: input data, each row is an observation, each column is an attribute
% ncluster: number of clusters to be segmented into
% cutType: 0 for NCut, 1 for RAssoc (default is NCut)
% scale: used to compute similarity graph  a(i,j) = exp(- (x_i -
%                                                        x_j)^2/scale^2)
function partition = graclusPortal(X, nclusters, cutType, scale)
    
    narginchk(2,4);
    if nargin == 2
        cutType = 0;
        [G,~] = compute_relation(X');
    elseif nargin == 3
        [G,~] = compute_relation(X');
    elseif nargin == 4 && isempty(scale)
        [G,~] = compute_relation(X');
    else
        [G,~] = compute_relation(X', scale);
    end
    
    [partition, ~] = graclus(G, nclusters, cutType);
    
%     clusters = cell(1,nclusters);
%     for i=1:nclusters
%         clusters{i} = X(partition == i,:);
%     end
    
    
end