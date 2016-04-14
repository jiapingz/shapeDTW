% convert from symbols to misclassification
function misc = symbols2misclassification(symbols)
	if ~isnumeric(symbols)
        error('The 1st parameter must be a numeric vector\n');
    end    
    % determine if symbols are integers
    % ideally, any data types are allowed, for simplicity,
    % we only allow integer type
    if sum(floor(symbols) == symbols) ~= numel(symbols)
        error('Make sure the 1st parameter is integer\n');
    end
     

    xvalues = min(symbols):max(symbols);

    nele  = hist(symbols,  xvalues);        
    nele = nele(nele ~= 0);    
    p = nele./sum(nele);
    misc = impurityMisclassification(p);

end