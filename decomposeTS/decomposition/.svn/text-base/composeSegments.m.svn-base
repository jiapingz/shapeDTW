% this function is used to search for top K splitting points, based on the
% decomposed tree
% input: decomposedTree, which is the output of 'buildDecomposeTree'
%        K, the # of splitting points to be searched
% output: a decomposed tree, based on K points
function decomposedTree =  composeSegments(t, K)
    iterator = t.depthfirstiterator;
    
    numNodes       = numel(iterator);
    segments        = cell(numNodes,1);
    subsequencesIdx = cell(numNodes,1);
    temporalIdx     = cell(numNodes,1);  
    flagLeaves      = zeros(numNodes,1) > 1;
    for i=1:numNodes 
        if ~t.isleaf(iterator(i))
            flagLeaves(i) = false;
            continue;
        end
        flagLeaves(i)   = true;
        tmpTree         = t.get(iterator(i));
        segments{i}     = tmpTree.timeseries;
        subsequencesIdx{i} = tmpTree.subsequencesIdx;
        temporalIdx{i}  = tmpTree.temporalIdx;
    end
    segments        = segments(flagLeaves);
    subsequencesIdx = subsequencesIdx(flagLeaves);
    temporalIdx     = temporalIdx(flagLeaves);
    
    numLeaves  = sum(flagLeaves);
    dists                = zeros(1, numLeaves-1);
    splitPtsIdx_temporal = zeros(1, numLeaves-1);
    for i=1:numLeaves-1
        seg1 = segments{i};
        seg2 = segments{i+1};
        dists(i) = shapeletTransform(seg1, seg2)/ ...
                        min([length(seg1) length(seg2)]);
         splitPtsIdx_temporal(i) = temporalIdx{i}(end);
    end
    
    [~, idx] = sort(dists, 'descend');
     splitPtsIdx_temporal = splitPtsIdx_temporal(idx);
    
    % build a split tree
    % basic information of the decomposed tree
    root = t.get(1);
    ts              = root.timeseries;    
    decomposedTree = tree(root);
    numNodes = 1;   
    
    K = min(K, length(splitPtsIdx_temporal));
    for k=1:K
        k_splitPtIdx = splitPtsIdx_temporal(k);
         for i=1:numNodes
                if decomposedTree.isleaf(i) == false
                    continue;
                end
                i_node = decomposedTree.get(i);
                i_temporalIdx       = i_node.temporalIdx;
                i_symbols           = i_node.representation;
                i_markers           = i_node.markers;
                i_subsequencesIdx   = i_node.subsequencesIdx;
                splitPt = find(i_temporalIdx == k_splitPtIdx);
                if isempty(splitPt)
                    continue;
                end
%                 splitPt = splitPt - i_temporalIdx(1) + 1;
                
                left_node   = validateDecomposeTreeNodeContent;
                right_node  = validateDecomposeTreeNodeContent;
                left_node.representation    = i_symbols(1:splitPt);                
                left_node.temporalIdx       = i_temporalIdx(1:splitPt);
                left_node.markers           = i_markers(1:splitPt);
                left_node.subsequencesIdx   = i_subsequencesIdx(1:splitPt);
                left_node.timeseries        = ...
                            ts(i_subsequencesIdx(1):i_subsequencesIdx(splitPt));
                
                right_node.representation    = i_symbols(splitPt+1:end);                
                right_node.temporalIdx       = i_temporalIdx(splitPt+1:end);
                right_node.markers           = i_markers(splitPt+1:end);
                right_node.subsequencesIdx   = i_subsequencesIdx(splitPt+1:end);
                right_node.timeseries        = ...
                            ts(i_subsequencesIdx(splitPt+1):i_subsequencesIdx(end));

                decomposedTree = decomposedTree.addnode(i, left_node);
                decomposedTree = decomposedTree.addnode(i, right_node);
                numNodes = numNodes + 2;  
                
         end
    end
 
    
end