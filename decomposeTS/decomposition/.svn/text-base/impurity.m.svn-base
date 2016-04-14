
function imp = impurity(p, criterion)
    if sum( p >= 0 ) ~= numel(p)
        error('Probability should be non-negative\n');
    end      
    switch criterion
        case 'entropy'
            imp = impurityEntropy(p);
        case 'misclassification'
            imp = impurityMisclassification(p);
        case 'gini'
            imp = impurityGini(p);
        otherwise
            error('The 2nd parameter should be Gini, entropy or misclassification\n');
    end
    
end