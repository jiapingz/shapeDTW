%% note: this function is just for visualization
% tree node content is not accurate for numerical computation

function prunedT =  pruneDecomposedTree(t, nKeepSplits)
% inputs:
%           t - decomposed tree
%           nLeftNodes - number of splits that you wanna keep

% methods:
%           instead of using chopping, we build a tree, with 'nKeepSplits'
%           nodes
%           this becomes easier than pruning, since in case of pruning, the
%           tree indices will keep changing with the pruning process
    
    narginchk(1,2);
    if isempty(nKeepSplits) || ~exist('nKeepSplits', 'var')
        prunedT = tree(t);
        return;
    end
    
    
    numNodes = nnodes(t);
    numLeafNodes = 0;
    for i=1:numNodes
         if t.isleaf(i)
            numLeafNodes = numLeafNodes + 1;
        end
    end
    
    nsplitPoints = numNodes - numLeafNodes;
    if nKeepSplits >= nsplitPoints
        prunedT = tree(t);
        return;
    end
    
    % build a tree, which has 'nKeepSplits' nodes
    rootNode = t.get(1);
    iNode = rootNode;
%     iNode = validateDecomposeTreeNodeContent(iNode);
    prunedT = tree(iNode);
    
    for i=1:nKeepSplits
        
         for j=1:numNodes
            jNode = t.get(j);
            jsplitOrder = jNode.splitOrder;
            if isempty(jsplitOrder)
                continue;
            end
            
            if jsplitOrder == i
                targetNodeIdx = j;
                break;
            end
         end
        
         cIdx = retrieveChildrenIdx(t, targetNodeIdx);
         cIdx = sort(cIdx, 'ascend');
         
         for j=1:numel(cIdx)
            prunedT = prunedT.addnode(targetNodeIdx, t.get(cIdx(j)));
         end
    end
    
end





