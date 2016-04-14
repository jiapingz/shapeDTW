
function imp = impurityMisclassification(p)
	if sum( p >= 0 ) ~= numel(p)
        error('Probability should be non-negative\n');
    end      
    imp = 1 - max(p);
    return;
end