% compute dynamic time warping distances between two sets
function d = dDTWsets(set1, set2, w)
    narginchk(2,3);
    if nargin == 2
        w = Inf;
    end 
    
    if ~iscell(set1) || ~iscell(set2)
        error('Wrong types of inputs\n');
    end
    
    nSet1 = numel(set1);
    nSet2 = numel(set2);
    dists = 0;
    
    for i=1:nSet1
        seq1 = set1{i};
        for j=1:nSet2
            seq2 = set2{j};
            dists = dists + dtw_c(seq1(:), seq2(:), w);
        end
    end
    
    d = dists/(nSet1*nSet2);
    
 end
