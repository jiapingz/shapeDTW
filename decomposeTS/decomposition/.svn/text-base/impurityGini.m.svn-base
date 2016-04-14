
function imp = impurityGini(p)
    if sum( p >= 0 ) ~= numel(p)
        error('Probability should be non-negative\n');
    end      
    imp = sum( p .* (1-p));
    return;
end