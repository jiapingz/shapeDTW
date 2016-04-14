% this function is very specific to our application
% it's different to the generic function 'splitGoodness' in that:
% additional information 'marker' should be provided.
% 'Marker' belongs to {-1 0 1}, where
% -1: valley, 0: flat, 1: peak

% make sure:
% symbols are integers, and the min-index is 1, and the max index 
% is nclasses
% ideally, we should support any kinds of data types, 
% for simplicity, we enforce 'symbols' to be integer
function gain = splitGoodness2(symbols, markers, splitPt, SplitModel)
    narginchk(3,4);
    if nargin == 3
        SplitModel = validateSplitModel;
    end
    if splitPt > numel(markers) || splitPt < 1 || ...
                numel(markers) ~= numel(symbols)
            error('Please check the input parameters\n');
    end
    
    switch markers(splitPt)
        case 1
            flag = markers ~= -1;
            t_symbols = symbols(flag);
            t_markers = markers(1:splitPt);
            cnt = sum(t_markers == -1);
            sPt = splitPt - cnt;
            gain = splitGoodness(t_symbols, sPt, SplitModel);
        case -1
            flag = markers ~= 1;
            t_symbols = symbols(flag);
            t_markers = markers(1:splitPt);
            cnt = sum(t_markers == 1);
            sPt = splitPt - cnt;
            gain = splitGoodness(t_symbols, sPt, SplitModel);
        case 0
            % case 1
            flag = markers ~= 1;
            t_symbols = symbols(flag);
            t_markers = markers(1:splitPt);
            cnt = sum(t_markers == 1);
            sPt = splitPt - cnt;
            gain1 = splitGoodness(t_symbols, sPt, SplitModel);
            
            % case 2
            flag = markers ~= -1;
            t_symbols = symbols(flag);
            t_markers = markers(1:splitPt);
            cnt = sum(t_markers == -1);
            sPt = splitPt - cnt;
            gain2 = splitGoodness(t_symbols, sPt, SplitModel);
            
            gain = max([gain1 gain2]);
        otherwise
            error('Please check the input parameter ''markers'' \n');
    end
    
    
end