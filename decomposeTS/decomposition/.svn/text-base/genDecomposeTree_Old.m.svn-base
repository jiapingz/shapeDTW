% produce a split tree of raw signals
% note: when computing information gain of different sub-signals, it's
% better to normalize the gain by lengths of sub-signals
    % varargin: there are two possible inputs
    % (1) depth: depth of the tree
    % (2) MinLeaf: minimal number of segments in each leaf node
    
function t = genDecomposeTree_Old(symbols, nclasses, varargin)

    %% (1)parameter preparation
    val_treeSetting = validateDecomposeTreeparam;
    val_treeSetting = prepareArgs(val_treeSetting); 
    len = length(val_treeSetting);
    default_setting_str = '';
    for i=1:2:len
        str = sprintf('''%s'',%d',val_treeSetting{i}, val_treeSetting{i+1});
        if i ~=1
            default_setting_str = sprintf('%s, %s', default_setting_str, str);
        else
            default_setting_str = str;
        end
    end
    
    str_command = sprintf('[depth, MinLeaf] = process_options(varargin, %s)', default_setting_str);
    eval(str_command);
    
    
    %% (2) build a parse tree of the signal(symbols)
    temporalIdx = 1:length(symbols);
    node = validateDecomposeTreeNodeContent;
    node.representation = symbols;   
    node.temporalIdx = temporalIdx;
%     node.timeseries = timeseries;
    t = tree(node);
    numNodes = 1;
    
   % while ind_depth <= depth && ind_minleaf >= MinLeaf
   
   while 1        
%         iterator = t.depthfirstiterator;
%         numNodes = max(iterator);
        dt = t.depthtree;
        
        flagLeaf    =   zeros(1, numNodes) > 1.0;
        flagSplit   =   zeros(1, numNodes) > 1.0;
        depthLeaf   =   zeros(1, numNodes) + Inf;
        gains       =   zeros(1, numNodes);
        lens        =   zeros(1, numNodes);
        for i=1:numNodes
            flagLeaf(i)  = t.isleaf(i);
            
            if flagLeaf(i) == false
                continue;
            end
            
            depthLeaf(i) = dt.get(i);
            flagSplit(i) = flagLeaf(i);
            i_node = t.get(i);
            if i_node.split == false
                flagSplit(i) = false;
                continue;
            end
            
            if flagSplit(i) == true && depthLeaf(i) < depth
                i_symbols = i_node.representation;
                i_len = length(i_symbols);
                if i_len <= MinLeaf
                    flagSplit(i) = false;
                    i_node.split = false;
                    t = t.set(i, i_node);
                    continue;
                end
                
                [splitPt, gain] = searchSplitPt(i_symbols, nclasses);
                i_node.infoGain = gain;
                i_node.splitPoint = splitPt;
                
                left_len = splitPt;
                right_len = i_len - left_len;
                
                if left_len < MinLeaf || right_len < MinLeaf
                    flagSplit(i) = false;
                    i_node.split = false;
                    t = t.set(i, i_node);
                    continue;
                end
                t           =   t.set(i, i_node);
                gains(i)    =   gain;
                lens(i)     =   i_len;
            else
                flagSplit(i) = false;
                
            end
            
        end
        
        idx      =  find(flagSplit);
        if isempty(idx)
            break;
        end
        
%         iterator =  iterator(idx);
        infoGain = -Inf + zeros(size(gains));
        gains    =  gains(idx);
        lens     =  lens(idx);
        
        infoGain(idx) = gains.*lens;
        [~, idx] = max(infoGain);
        idx_splitNode = idx; % iterator(idx);
        
        
        splitNode = t.get(idx_splitNode);
        split_symbols = splitNode.representation;
        split_temporalIdx = splitNode.temporalIdx;
        splitPt       = splitNode.splitPoint;
        
        left_node   = validateDecomposeTreeNodeContent;
        right_node  = validateDecomposeTreeNodeContent;
        left_node.representation    = split_symbols(1:splitPt);                
        left_node.temporalIdx       = split_temporalIdx(1:splitPt);
        right_node.representation   = split_symbols(splitPt+1:end);
        right_node.temporalIdx      = split_temporalIdx(splitPt+1:end);
        
        t = t.addnode(idx_splitNode, left_node);
        t = t.addnode(idx_splitNode, right_node);
        numNodes = numNodes + 2;
        
    end
    
    
    
    
end

