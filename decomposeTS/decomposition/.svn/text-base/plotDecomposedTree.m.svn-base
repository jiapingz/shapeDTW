% plot decomposed tree
function plotDecomposedTree(decomposedTree, vd, plotReference)
    narginchk(1,3);
    if ~exist('vd', 'var') || isempty(vd)
        vd = 1;
    end
    
    if ~exist('plotReference', 'var') || isempty(plotReference)
        plotReference = 'time-series';
    end
    
    % get the plot configuration of each node in t
%      anchorTree = genLayoutDecomposedTree(decomposedTree, plotReference);
%     anchorTree = genLayoutDecomposedTree2(decomposedTree, plotReference);
    anchorTree = genLayoutDecomposedTree3(decomposedTree, plotReference);
    skeletonTree = genSkeletonDecomposedTree(decomposedTree, anchorTree);
    
	iterator = decomposedTree.depthfirstiterator; 
    nNodes = max(iterator);
    if nNodes <= 1
        figure;
        return;
    end
    % plot decomopsed tree
    figure;  
%     set(gca, 'Position', [0 0 1 1]); 
    for j=1:nNodes
        pos = anchorTree.get(j);
        pos = double(pos);
        jt = decomposedTree.get(j);
        jTimeSeries = jt.timeseries;
        jTimeSeries = jTimeSeries(:,vd);
        jInfoGains  = jt.infoGains;
        jSubsequencesIdx = jt.subsequencesIdx;
        
        bLeaf = decomposedTree.isleaf(j);

        switch plotReference
            case 'time-series'
                jx =  1:length(jTimeSeries);
                jx = jx + round(pos(1)  - length(jTimeSeries)/2);
                jy = pos(2) + jTimeSeries - mean(jTimeSeries);
            case 'info-gain'
                jx =  jSubsequencesIdx;
                jx = jx + round(pos(1)  - median(jSubsequencesIdx));
                jy = pos(2) + jInfoGains - mean(jInfoGains);
            otherwise
                error('Only support to either plot ''time series'', or plot ''info gain''\n');
        end
        plot(jx,jy, 'linewidth', 2, 'color', 'b');  
        hold on;

%     	jLinfoGain = jt.LinfoGain;
%       jRinfoGain = jt.RinfoGain;
      infoGain = jt.infoGain * length(jt.representation);
%       entropy = symbols2entropy(jt.representation);
%       hold on;        
%     	text(jx(1)-5, pos(2), sprintf('%.1f', jLinfoGain), 'color', 'k'); hold on;
%       text(jx(end), pos(2), sprintf('%.1f', jRinfoGain), 'color', 'k'); hold on;
        if ~bLeaf
%             text(pos(1), pos(2) + 2, sprintf('%.1f', infoGain), 'color', 'k', 'fontsize', 27); hold on;
        end
    end
    % plot edge
    edgeTree = tree(skeletonTree);
    for j=1:nNodes
        p = edgeTree.getparent(j);
        if p == 0
            continue;
        end
        jshift = edgeTree.get(j);
        pshift = edgeTree.get(p);
        plot([jshift(1) pshift(1)], [jshift(2) pshift(2)], 'linewidth', 1, 'color','r');
        hold on;        
    end
%     set (gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);
	set(gca,    'xtick',[],'ytick',[] , 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
    axis tight;

end

