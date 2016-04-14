function skeleton = genSkeletonDecomposedTree(t, anchorTree)
% inputs:
%         t - a decomposed tree
%         anchorTree - generated anchor tree of t
% output:
%       skeleton - a skeleton tree
    
    skeleton = tree(t, []);
    
    numnodes = nnodes(t);
    
    for i=1:numnodes
%         i_node = t.get(i);
        flag = t.isleaf(i);
        if flag == true
            skeleton = skeleton.set(i, anchorTree.get(i));
        else
            i_pos = anchorTree.get(i);
            i_node_tree = t.get(i);
            i_len = length(i_node_tree.timeseries);
            i_subsequencesIdx = i_node_tree.subsequencesIdx;
            i_splitPt = i_node_tree.splitPoint;
            i_lmargin = i_subsequencesIdx(i_splitPt) - i_subsequencesIdx(1);
            i_x = i_pos(1) - i_len/2 + i_lmargin;
            skeleton = skeleton.set(i, [i_x i_pos(2)]);
            
        end
        
        
    end


end