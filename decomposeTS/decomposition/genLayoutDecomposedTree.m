% this function is used to compute planar configurations of tree nodes
% this function is very specific to our application, for the visualization
% of decomposed time series

function anchorTree = genLayoutDecomposedTree(decomposedTree, reference)
    narginchk(1,2);
    
    if nargin == 1
        reference = 'time-series';
    elseif nargin == 2
        tf = strcmp(reference, {'time-series', 'info-gain'});
        if sum(tf) == 0
            error('Now only support two kinds of layouts\n');
        end
    end

    anchorTree = tree(decomposedTree, []);
    dt = decomposedTree.depthtree;
    depth = dt.depth;

    

    cntSiblings = zeros(depth,1);    
    for i=1:depth
        indices = find(dt == i);
        cntSiblings(i) = numel(indices);        
    end   
    maxSiblings = max(cntSiblings);
    
    root = decomposedTree.get(1);
    timeseries = root.timeseries;
    
    % place to set the horizontal and vertical gaps
    % y-gap is set to be 2 times as the magnitude
    % x-gap is set to be 1/10 of the length of the signal
    
    switch reference
        case 'time-series'
            mag = max(timeseries) - min(timeseries);
            gapY = 2*mag;    
        case 'info-gain'
%             mag = max(infoGains) - min(infoGains);
            iterator = decomposedTree.depthfirstiterator;
            mag_var_infoGain = 0;
            for i=iterator
                i_node = decomposedTree.get(i);
                i_infoGains = i_node.infoGains;
                if max(i_infoGains) - min(i_infoGains) > mag_var_infoGain
                    mag_var_infoGain = max(i_infoGains) - min(i_infoGains);
                end
            end
            gapY = 2*mag_var_infoGain;    
        otherwise
            error('Now only support two kinds of layouts\n');
    end
    
    len = length(timeseries);
    gapX = 0.1*len;
    spanX = len + gapX*maxSiblings;
    
    for i=depth:-1:0
        indices = find(dt == i);
        nSiblings = length(indices);
        
%         xMargin = (spanX - len - (nSiblings-1)*gapX)/2;
        
        yCenter = gapY*(depth-i);
        
        tOrder = zeros(size(indices));
        tLen = zeros(size(indices));
        
        for j=1:length(indices)
            j_node = decomposedTree.get(indices(j));
            tOrder(j) = median(j_node.temporalIdx);
            tLen(j) = length(j_node.timeseries);
        end
        
        xMargin = (spanX  - sum(tLen) - (nSiblings-1)*gapX)/2;

        
        [~, idx] = sort(tOrder, 'ascend');
        indices = indices(idx);
        tLen = tLen(idx);
        tLenCum = [0 cumsum(tLen)];
                
       
        for j=1:length(indices)
            xshift = xMargin + (j-1)*gapX + tLenCum(j) + tLen(j)/2;
            anchorTree = anchorTree.set(indices(j), [xshift, yCenter]);
        end
      
    end
    
    
end

