
function [ptsIdx, infoGain, order] = getSplitPts(t)
% input: a decomposed tree
%        the node in the tree has these fields: validateNoteContent.m
    iterator        = t.depthfirstiterator;    
    numNodes        = numel(iterator);   
	subsequencesIdx = cell(numNodes,1);
    t_infoGain      = zeros(numNodes,1);
    splitPts_order  = zeros(numNodes,1);
    
    flagLeaves      = zeros(numNodes,1) > 1;
    for i=1:numNodes 
        if ~t.isleaf(iterator(i))
            flagLeaves(i) = false;
            continue;
        end
        flagLeaves(i)       = true;
        tmpTree             = t.get(iterator(i));   
        subsequencesIdx{i}  = tmpTree.subsequencesIdx;
        t_infoGain(i)       = tmpTree.RinfoGain;
        splitPts_order(i)   = tmpTree.Rorder;
    end

	subsequencesIdx = subsequencesIdx(flagLeaves);
    t_infoGain      = t_infoGain(flagLeaves);
    splitPts_order  = splitPts_order(flagLeaves);
    
    numLeaves   = sum(flagLeaves);    
    ptsIdx      = zeros(1, numLeaves-1);
    infoGain    = zeros(1, numLeaves-1); 
    order       = zeros(1, numLeaves-1);
    for i=1:numLeaves-1
         ptsIdx(i)    = subsequencesIdx{i}(end);
         infoGain(i)  = t_infoGain(i);
         order(i)     = splitPts_order(i);
    end
    
end