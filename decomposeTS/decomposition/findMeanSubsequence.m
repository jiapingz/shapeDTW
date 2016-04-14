% find the mean subsequence, such that:
% sum( s - me) is minimal
function meSubsequence = findMeanSubsequence(subsequences)

    nSubsequences = numel(subsequences);
    dists = zeros(nSubsequences, nSubsequences);
    
    for i=1:nSubsequences
        r = subsequences{i};
        for j=i+1:nSubsequences
            t = subsequences{j};
            dists(i,j) = dtw_c(r,t);
        end
    end
    
    dists = dists + dists';

    sumdists = sum(dists,2);
    [~ , idx] = min(sumdists);
    
    meSubsequence = subsequences{idx};

end