
function imp = impurityEntropy(p)
    if sum( p >= 0 ) ~= numel(p)
        error('Probability should be non-negative\n');
    end    
    imp =  sum(-p.*log2(p));
    return;
end