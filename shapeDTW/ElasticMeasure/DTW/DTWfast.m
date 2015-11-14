function [dist, match] = DTWfast(p,q)
    narginchk(2,2);
    [lenp, dimsp] = size(p);
    [lenq, dimsq] = size(q);
    
    if lenp < dimsp || lenq < dimsq
        warning('Each dimension of signal should be organized columnwisely\n');
    end
    
    if dimsp ~= dimsq
        error('two sequences should be of the same dimensions\n');
    end
    
    d = dist2(p, q);
	d = sqrt(d);
    [idxp, idxq, cD, pc] = dpfast(d);

	match =[idxp' idxq'];    
    dist = sum(pc);
 
end