%% this function is a more advanced one than 'genDecomposeTree'
% problem to fix: homogeneous 

% build a split tree of raw signals
% note: when computing information gain of different sub-signals, it's
% better to normalize the gain by lengths of sub-signals
    % varargin: there are two possible inputs
    % (1) depth: depth of the tree
    % (2) MinLeaf: minimal number of segments in each leaf node
    
% this function is applicable to both univariate & multivariate time series
% NOTE: each dimension of time series is arranged column-wisely
    
function t = buildDecomposeTree(timeseries, subsequencesIdx, markers,...
                                            symbols, treeSetting)

    %% (1) parameter preparation
%     val_treeSetting = validateDecomposeTreeparam
%     val_treeSetting = prepareArgs(val_treeSetting); 
%     len = length(val_treeSetting);
%     default_setting_str = '';
%     for i=1:2:len
%         str = sprintf('''%s'',%d',val_treeSetting{i}, val_treeSetting{i+1});
%         if i ~=1
%             default_setting_str = sprintf('%s, %s', default_setting_str, str);
%         else
%             default_setting_str = str;
%         end
%     end
%     
%     str_command = sprintf('[depth, MinLeaf] = process_options(varargin, %s)', default_setting_str);
%     eval(str_command);

    val_treeSetting = validateDecomposeTreeparam(treeSetting);
    depth       =   val_treeSetting.depth;
    minlen      =   val_treeSetting.minlen;  
    splitModel  =   val_treeSetting.splitModel;
    
    %% step 1: build a parse tree of the signal(symbols)
    temporalIdx = 1:length(symbols);
    node = validateDecomposeTreeNodeContent;
    node.representation     = symbols;   
    node.markers            = markers;
    node.subsequencesIdx    = subsequencesIdx;
    node.temporalIdx            = temporalIdx;
    node.LinfoGain      = 0;
    node.RinfoGain      = 0;
    node.Lorder           = 0;
    node.Rorder           = 0;
%     node.timeseries = timeseries;
    t = tree(node);
    numNodes    = 1;   
    nSplitPts   = 0;
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
                i_markers = i_node.markers;
                i_temporalIdx = i_node.temporalIdx;
%                 i_len = length(i_symbols);
                i_len = subsequencesIdx(i_temporalIdx(end)) - ...
                            subsequencesIdx(i_temporalIdx(1));
                if i_len <= minlen
                    flagSplit(i) = false;
                    i_node.split = false;
                    t = t.set(i, i_node);
                    continue;
                end
                
                 [splitPt, splitPtGain] = searchSplitPt(i_symbols, splitModel);
%                [splitPt, gain] = searchSplitPt2(i_symbols, i_markers, splitModel);

                 i_node.infoGain = splitPtGain;
                 i_node.splitPoint = splitPt;
                 
                left_len = subsequencesIdx(i_temporalIdx(1) + splitPt - 1) - ...
                                       subsequencesIdx(i_temporalIdx(1));
                right_len = subsequencesIdx(i_temporalIdx(end)) - ...
                                       subsequencesIdx(i_temporalIdx(1) + splitPt - 1);
                
%                 left_len = splitPt;
%                 right_len = i_len - left_len;
                
                if left_len < minlen || right_len < minlen
                    flagSplit(i) = false;
                    i_node.split = false;
                    t = t.set(i, i_node);
                    continue;
                end
                t           =   t.set(i, i_node);
                gains(i)    =   splitPtGain;
%                 lens(i)     =   i_len; %% how to weigh each split point
                lens(i) = length(i_symbols);
            else
                flagSplit(i) = false;                
            end            
        end
        
        idx      =  find(flagSplit);
        if isempty(idx)
            break;
        end  
        nSplitPts = nSplitPts + 1;
%         iterator =  iterator(idx);
        infoGain = -Inf + zeros(size(gains));
        gains    =  gains(idx);
        lens     =  lens(idx);
        
        infoGain(idx) = gains.*lens;
        [~, idx] = max(infoGain);
        idx_splitNode = idx; % iterator(idx);        
        
        splitNode = t.get(idx_splitNode);
        splitNode.splitOrder = nSplitPts;
        t = t.set(idx_splitNode, splitNode);
        split_symbols = splitNode.representation;
        split_markers = splitNode.markers;
        split_subsequencesIdx  = splitNode.subsequencesIdx;
        split_temporalIdx = splitNode.temporalIdx;
        splitPt       = splitNode.splitPoint;
        
        left_node   = validateDecomposeTreeNodeContent;
        right_node  = validateDecomposeTreeNodeContent;
        left_node.representation    = split_symbols(1:splitPt);                
        left_node.temporalIdx       = split_temporalIdx(1:splitPt);
        left_node.markers           = split_markers(1:splitPt);
        left_node.subsequencesIdx   = split_subsequencesIdx(1:splitPt);
        left_node.LinfoGain = splitNode.LinfoGain;
        left_node.RinfoGain = infoGain(idx);
        left_node.Lorder = splitNode.Lorder;
        left_node.Rorder = nSplitPts;
        right_node.representation   = split_symbols(splitPt+1:end);
        right_node.temporalIdx      = split_temporalIdx(splitPt+1:end);
        right_node.markers          = split_markers(splitPt+1:end);
        right_node.subsequencesIdx  = split_subsequencesIdx(splitPt+1:end);
        right_node.LinfoGain = infoGain(idx);
        right_node.RinfoGain = splitNode.RinfoGain;
        right_node.Lorder = nSplitPts;
        right_node.Rorder = splitNode.Rorder;
        
        t = t.addnode(idx_splitNode, left_node);
        t = t.addnode(idx_splitNode, right_node);
        numNodes = numNodes + 2;        
   end
    
   % step 2:  (1) add raw time series into the decomposed tree
   %             (2) add splitGain information to each point
   %            note: information gain of 
    iterator = t.depthfirstiterator; 
    nNodes = max(iterator);
 
    % setting 'timeseries' field of tree t
    for j=1:nNodes
        jt = t.get(j);
        % set time series
        temporalIdx = jt.temporalIdx;
        sidx = subsequencesIdx(temporalIdx(1));
        eidx = subsequencesIdx(temporalIdx(end));
        jt.timeseries = timeseries(sidx:eidx,:);
        % set information gains
        j_symbols = jt.representation;
        [~,~, gains] = searchSplitPt(j_symbols, splitModel);
        jt.infoGains = gains;
        t = t.set(j, jt);
    end
    
end

