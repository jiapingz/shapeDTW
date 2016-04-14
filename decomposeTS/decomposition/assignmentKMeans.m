% two inputs: centers, k-means clustering centers
%           descriptors, descriptors of subsequences
% output: assignments of descriptors to centers

% both inputs should be of matrix type
% each row of centers is a clustering center
% each row of descriptors is a descriptor of one subsequence
function assignments = assignmentKMeans(descriptors, centers)
    if ~ismatrix(centers) || ~ismatrix(descriptors) || ...
            size(centers,2) ~= size(descriptors,2)
        error('Please make sure both inputs are of matrix type\n');
    end

    num = size(descriptors,1);
    K = size(centers,1);
    assignments = zeros(num,1);
    for j=1:num
       [~, assignments(j)] = ...
           min(sum((repmat(descriptors(j,:), K,1) - centers).^2, 2));
    end
end