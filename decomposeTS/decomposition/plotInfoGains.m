function plotInfoGains(timeseries, samplingSetting, descriptorSetting, ...
                                        clustSetting, splitModel, gtTransitions)
% plot information gain
% input: univariate time series
%        samplingSetting:   sampling method, hybrid sampling (default)
%        descriptorSetting:  subsequence descriptors, hog (default)
%        splitModel: what kinds of index to measure the purity and
%        information gain

    narginchk(1,6);
    if min(timeseries) == max(timeseries)
        figure;
        return;
    end
    if ~exist('samplingSetting', 'var') || isempty(samplingSetting)
        samplingSetting = struct('method', 'hybrid',...
                         'param', struct('sel', 8, ...
                                         'seqlen', 62, ...
                                         'stride', 30));
        samplingSetting = validateSamplingSetting(samplingSetting);
    end
    
    if ~exist('descriptorSetting', 'var') || isempty(descriptorSetting)
        hog = validateHOG1Dparam;
        seqlen  = samplingSetting.param.seqlen;
        hog.cells    = [1 round(seqlen/2)];
        hog.overlap = 0;
        hog.xscale  = 0.1;

        descriptorSetting = struct('method', 'HOG1D', ...
                                   'param', hog);
    end
    
    if ~exist('clustSetting', 'var') || isempty(clustSetting)
        K_kmeans = 10;                       
        clust_method = 'kmeans';
        clust_param = validateKMeansparam;
        clust_param.nclusters = K_kmeans;
        clustSetting.method = clust_method;
        clustSetting.param  = clust_param;
    end
    
    if ~exist('splitModel', 'var') || isempty(splitModel)
        splitModel = struct('criterion', 'entropy', ...
                            'nclasses', 10, ...
                            'dissimilarity', []);
        splitModel = validateSplitModel(splitModel);
    end
    
    if ~exist('gtTransitions', 'var') || isempty(gtTransitions)
        gtTransitions = [];
    end
    
    % step one: sampling and representation
    [symbols, subsequencesIdx] =  ...
        symbolizeTSindividually(timeseries, samplingSetting, descriptorSetting, clustSetting);
    
    % step two: compute information gain at each candidate split point
	[~, ~ , gains] = searchSplitPt(symbols, splitModel);
    
    
    % plot
    figure;
	h = axes('Position', [0.1 0.55 0.8 0.35]);    
    plot(timeseries, 'b', 'LineWidth',2); hold on;
    scatter(subsequencesIdx, timeseries(subsequencesIdx), 50, 'o', 'markeredgecolor', 'g', 'markerfacecolor', 'g' );  hold on;
    if ~isempty(gtTransitions)
        scatter(gtTransitions, timeseries(gtTransitions), 100, 'o', 'markeredgecolor', 'k', 'markerfacecolor', 'k' );  hold on;
    end
    xlim([1, length(timeseries)]);
    ylim([min(timeseries) max(timeseries)]);
%     set(h,    'xtick',[], 'xticklabel', [], 'ytick',[] , 'yticklabel', [], 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
    set(h,  'xtick',[], 'xticklabel', [], 'XColor', [1 1 1])  ;

    h = axes('Position', [0.1 0.1 0.8 0.35]);
    plot(subsequencesIdx, gains, 'r', 'lineWidth', 2); hold on;
	scatter(subsequencesIdx, gains, 50, 'o', 'markeredgecolor', 'g', 'markerfacecolor', 'g' );  hold on;
    if ~isempty(gtTransitions)
        gtGains = zeros(size(gtTransitions)) + mean(gains);
        for i=1:numel(gtTransitions)
            lflag = subsequencesIdx > gtTransitions(i);
            idx = find(lflag,1);
%             sflag = subsequencesIdx <= gtTransitions(i);
            if ~isempty(idx)                
                gtGains(i) = gains(idx);
            end
        end
        scatter(gtTransitions, gtGains, 100, 'o', 'markeredgecolor', 'k', 'markerfacecolor', 'k' );  hold on;
    end
    xlim([1, length(timeseries)]);
    ylim([min(gains) max(gains)]);
%     set(h,  'xtick',[], 'xticklabel', [], 'ytick',[] , 'yticklabel', [], 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
    set(h,  'xtick',[], 'xticklabel', [], 'XColor', [1 1 1])  ;
 
	set(gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);
                              
end