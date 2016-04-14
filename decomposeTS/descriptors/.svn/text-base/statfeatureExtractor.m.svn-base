% extract  statistical features for a time series sequence
% note: the input of the seq is a 1D vector
function [feats, activefeatNames] = statfeatureExtractor(seq, ...
                            statfeatureLists, field2function)
     
    if nargin ~= 3
        error('There should be 3 input parameters\n');
    end
    
    if ~isstruct(statfeatureLists) || ~isstruct(field2function)
        error('the 2nd and 3rd parameter should be structs\n');
    end
   
    %{
    statfeatureLists = struct('mean',      true, ...
                               'std',       true, ...
                               'rms',       true, ...
                               'meanderivative',    true, ...
                               'meancrossingrate',  true);
    field2function = struct('mean',             'meanSeq', ...
                            'std',              'stdSeq', ...
                            'rms',              'rmsSeq', ...
                            'meanderivative',   'meanDerivative', ...
                            'meancrossingrate', 'meancrossingRate');
    %}

    featNames = fieldnames(statfeatureLists);
    activefeatNames = {};
    nfeats = 0;
    for i=1:size(featNames,1)
        flag = getfield(statfeatureLists, featNames{i});
        if flag == true
            activefeatNames = [activefeatNames; featNames{i}];
            nfeats = nfeats + 1;
        end
    end

    feats = [];
    for i=1:nfeats    
        str = sprintf('res = %s(seq);', getfield(field2function, activefeatNames{i}));
        eval(str);
        if ~isscalar(res)
            res = res(:);
        end
        feats = [feats; res];
    end

end



