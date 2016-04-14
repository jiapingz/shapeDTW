
samplingSetting = struct('method', 'hybrid',...
                         'param', struct('sel', 5, ...
                                         'seqlen', 52, ...
                                         'stride', 25));
dataDir = '/lab/jiaping/projects/google-glass-project/data/glass-processed-data-more/Glass-prepared-data';
dataFile = 'processed-data-yaccel.mat';
saveDir = '/lab/jiaping/projects/google-glass-project/results/TS-gradients';

if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

if ispc
    slash = '\';
else
    slash = '/';
end

%% read data from files
data_read     = load(strcat(dataDir, slash, dataFile));
sensordata    = data_read.data;
activityNames = data_read.activityNames;
labels        = data_read.labels;

 nSamples = numel(sensordata);
%% calculate gradients of time series
 for i=1:nSamples
    
     saveName = sprintf('%s-%d.png', strcat(saveDir, slash, activityNames{labels(i)}),i);
     if exist(saveName, 'file')
%           continue;
     end

    TS = sensordata{i}{1};       
    [gradients, subsequencesIdx] = ...
                            calcGradientsTimeSeries(TS, samplingSetting);
    % plot
    figure; 
    h = axes('position', [0.1 0.1 0.8 0.4]);
    plot(TS, 'color', 'b', 'linewidth',2);  hold on;    
    scatter(subsequencesIdx, TS(subsequencesIdx), 50, 'o', 'markeredgecolor', 'g', 'markerfacecolor', 'g' );    
    
	xlim([1, length(TS)]);
    ylim([min(TS) max(TS)]);
%     set(h,    'xtick',[], 'xticklabel', [], 'ytick',[] , 'yticklabel', [], 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
    set(h,  'xtick',[], 'xticklabel', [], 'XColor', [1 1 1])  ;
    
    h = axes('position', [0.1 0.5 0.8 0.4]);
    plot(subsequencesIdx,   gradients, 'color', 'b', 'linewidth',2); 
	
    xlim([1, length(TS)]);
    ylim([min(gradients) max(gradients)]);
%     set(h,    'xtick',[], 'xticklabel', [], 'ytick',[] , 'yticklabel', [], 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
    set(h,  'xtick',[], 'xticklabel', [], 'XColor', [1 1 1])  ;

      
    set(gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);

 	title(activityNames{labels(i)}, 'fontsize', 30);
 	export_fig(saveName, '-png', '-m1', gcf);
    close all; 
  
 end

