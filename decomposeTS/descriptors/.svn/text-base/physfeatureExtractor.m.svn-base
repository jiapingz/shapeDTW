% extract  statistical features for a time series sequence
% the input of the vector seq is a matrix, with column indicating axis
function [feats, activefeatNames] = physfeatureExtractor(seq, ...
                            physfeatureLists, field2function)
     
    if nargin ~= 3
        error('There should be 3 input parameters\n');
    end
    
    if ~isstruct(physfeatureLists) || ~isstruct(field2function)
        error('the 2nd and 3rd parameter should be structs\n');
    end
    
    %{
    physfeatureLists = struct('meanMI', true, ...
                          'stdMI', true, ...
                          'NSM', true, ...
                          'accelEnergy', true, ...
                          'corrcoef', true);
                      
    field2function = struct('meanMI', 'meanMotionIntensity', ...
                            'stdMI', 'stdMI', ...
                            'accelEnergy', 'accelEnergy', ...
                            'corrcoef', 'corrcoef');
    %}

    featNames = fieldnames(physfeatureLists);
    activefeatNames = {};
    nfeats = 0;
    for i=1:size(featNames,1)
        if getfield(physfeatureLists, featNames{i}) == true
            activefeatNames = [activefeatNames; featNames{i}];
            nfeats = nfeats + 1;
        end
    end
   
    feats = [];
    for i=1:nfeats    
        str = sprintf('res = %s(seq);', getfield(field2function, activefeatNames{i}));
        eval(str);
        % in this case, we only consider correlation between Y and Z
        % directions
        if logical(strcmp(activefeatNames{i},  'corrcoef')) 
            if size(seq,2) == 3
                res = res(2,3);
            elseif size(seq,2) == 2
                res = res(1,2);
            else
                res = 0;
            end
        end
        if ~isscalar(res)
            res = res(:);
        end
        feats = [feats; res];
    end

end

