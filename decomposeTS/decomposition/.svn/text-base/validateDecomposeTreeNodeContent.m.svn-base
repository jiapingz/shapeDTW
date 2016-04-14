
function node = validateDecomposeTreeNodeContent()
    if nargin ~= 0
        error('There should be zero inputs\n');
    end
    
    node = struct('timeseries',     [], ...     % raw time series data
                  'representation', [], ...     % symbols
                  'markers',        [], ...     % {-1,0,1}, valley, flat & peak
                  'temporalIdx',    [], ...     % temporal indices of symbols 1,2,3, ...
                  'subsequencesIdx',[], ...     % pts indices in time series, e.g., 1, 25, 53, 79 ...
                  'split',          true, ...   % indicator: split or not 
                  'splitPoint',     [], ...     % split point: search for the split point
                  'infoGain',       [], ...     % information gain of the split point
                  'LinfoGain',      [], ...     % infoGain of left vertex of a subsequence                
                  'Lorder',         [], ...     % split order of the left vertex of a subsequence
                  'RinfoGain',      [], ...     % infoGain of right vertex of a subsequence
                  'Rorder',         [], ...     % split order of the right vertex of a subsequence
                  'infoGains',      [], ...     % information gains of all candidate points        
                  'splitOrder',     []);        % the order of its split point
                    % 'Lend', [] ,,,
                    % 'Rend', [])
    return;
end

