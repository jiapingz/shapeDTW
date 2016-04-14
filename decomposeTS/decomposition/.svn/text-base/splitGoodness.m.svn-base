% make sure:
% symbols are integers, and the min-index is 1, and the max index 
% is nclasses
% ideally, we should support any kinds of data types, 
% for simplicity, we enforce 'symbols' to be integer
function gain = splitGoodness(symbols, splitPt, SplitModel)
    narginchk(2,3);    
    if nargin == 2
        SplitModel = validateSplitModel;
    end 
    SplitModel = validateSplitModel(SplitModel);    
    criterion       =  SplitModel.criterion;
    dissimilarity   =  SplitModel.dissimilarity;
    nclasses        =  SplitModel.nclasses;
    
	if ~isnumeric(symbols)
        error('The 1st parameter must be a numeric vector\n');
    end    
    % determine if symbols are integers
    % ideally, any data types are allowed, for simplicity,
    % we only allow integer type
    if sum(floor(symbols) == symbols) ~= numel(symbols)
        error('Make sure the 1st parameter is integer\n');
    end
    
     
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
        

    
    switch criterion
        case {'entropy', 'misclassification', 'gini'}
            
            xvalues = min(symbols):max(symbols);

            nele  = hist(symbols,  xvalues);    
            nele1 = hist(symbols1, xvalues);
            nele2 = hist(symbols2, xvalues);

            nele = nele(nele ~= 0);
            nele1 = nele1(nele1 ~= 0);
            nele2 = nele2(nele2 ~= 0);

            p = nele./sum(nele);
            p1 = nele1./sum(nele1);
            p2 = nele2./sum(nele2);
            
            imp  = impurity(p, criterion);
            imp1 = impurity(p1,criterion);
            imp2 = impurity(p2,criterion);
        case 'spreadness'
            if isempty(dissimilarity) || ~ismatrix(dissimilarity)
                error('Check the input parameter setting of splitModel\n');
            end            
            xvalues = 1:nclasses;

            nele  = hist(symbols,  xvalues);    
            nele1 = hist(symbols1, xvalues);
            nele2 = hist(symbols2, xvalues);

            p = nele./sum(nele);
            p1 = nele1./sum(nele1);
            p2 = nele2./sum(nele2);            
            
            imp  = spreadness(p,dissimilarity);
            imp1 = spreadness(p1,dissimilarity);
            imp2 = spreadness(p2,dissimilarity);
        otherwise
            error('Check the split model parameter settings\n');
    end
    
    gain = imp - imp1*per1 - imp2*per2;
  
end