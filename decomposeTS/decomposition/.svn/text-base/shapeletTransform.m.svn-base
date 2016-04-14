% dynamic time warping distance and min pooling
function d = shapeletTransform(sequence1, sequence2)
    narginchk(2,2);
    
    if ~isvector(sequence1) || ~isvector(sequence2)
        error('Inputs should be in form of vector\n');
    end
    
    len1 = length(sequence1);
    len2 = length(sequence2);
    
    if len1 < len2
        template = sequence1(:);
        dists = zeros(1, len2-len1+1);
        for i=1:len2-len1+1
            target = sequence2(i:i+len1-1);
            dists(i) = dtw_c(template, target);
        end
        d = min(dists);
    else
        template = sequence2(:);
        dists = zeros(1, len1-len2+1);
        for i=1:len1-len2+1
            target = sequence1(i:i+len2-1);
            dists(i) = dtw_c(template, target);
        end
        d = min(dists);
    end
    
end