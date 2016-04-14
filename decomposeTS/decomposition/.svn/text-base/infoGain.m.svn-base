% compute information gain for some split

function gain = infoGain(symbols, splitPt)
    narginchk(1,2);
    if nargin == 1
        splitPt = round(numel(symbols)/2);
    end
    
    if ~isnumeric(symbols)
        error('The 1st parameter must be a numeric vector\n');
    end
    
    % determine if symbols are integers
    % ideally, any data types are allowed, for simplicity,
    % we only allow integer type
    if sum(floor(symbols) == symbols) ~= numel(symbols)
        error('Make sure the 1st parameter is integer\n');
    end
    
%     if min(symbols) < 1
%         error('Make sure the cluster idx starts from 1\n');
%     end
    
%     xvalues = 1:nclasses;
    xvalues = min(symbols):max(symbols);
    
    if splitPt == numel(symbols)
        gain = 0;
        return;
    elseif splitPt < 1
        gain = 0;
        return;
    end        
    
    symbols1 = symbols(1:splitPt);
    symbols2 = symbols(splitPt+1:end);
    
    len  = numel(symbols);
    len1 = numel(symbols1);
    len2 = numel(symbols2);
    per1 = len1/len;
    per2 = len2/len;
        
    nele  = hist(symbols,  xvalues);    
    nele1 = hist(symbols1, xvalues);
    nele2 = hist(symbols2, xvalues);
    
    nele = nele(nele ~= 0);
    nele1 = nele1(nele1 ~= 0);
    nele2 = nele2(nele2 ~= 0);
    
    p = nele./sum(nele);
    p1 = nele1./sum(nele1);
    p2 = nele2./sum(nele2);
    
    en =  -sum(p.*log2(p));
    en1 = -sum(p1.*log2(p1));
    en2 = -sum(p2.*log2(p2));
    
    gain = en - en1*per1 - en2*per2;
    
end