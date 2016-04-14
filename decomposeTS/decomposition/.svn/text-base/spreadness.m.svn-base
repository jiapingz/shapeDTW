% measure the spreadness of a distribution
% similar to computation of entropy, the main difference is:
% the former one disregards differences among different mdoes, while
% the latter one takes the difference into consideration.

% inputs: p, probabilities of each mode
%         distMat, distances between each pair of modes

% this measure is pretty similar to Gni index:
% Gini index: sigma{ p_i * (1-p_i)}
% while ours: sigma{ p_i * (1-p_i)}/2, if the distMat is identity

% wheather we can show the superiority of 'spreadness'
% over 'Gini Index' & 'entropy'

function dist = spreadness(p,dissimilarity)
    narginchk(2,2);
    if ndims(dissimilarity) ~= 2 || ...
            size(dissimilarity,1) ~=  size(dissimilarity,2)
        error('Make sure the 2nd parameter is a symmetric 2D matrix\');
    end
    
    nModes = numel(p);
    if nModes ~= size(dissimilarity,1)
        error('check the dimensionality of two inputs\n');
    end
    
    nzIdx = find(p);
    dist = 0;
    nzModes = numel(nzIdx);
    
    for i=1:nzModes
        idx1 = nzIdx(i);
        for j=i+1:nzModes
            idx2 = nzIdx(j);
            dist = dist + p(idx1)*p(idx2)*dissimilarity(idx1,idx2);
        end
    end
    
end