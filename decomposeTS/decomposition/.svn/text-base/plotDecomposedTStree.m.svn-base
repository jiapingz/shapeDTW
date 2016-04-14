% plot decomposed tree
init;
symbolFile = '/lab/jiaping/projects/google-glass-project/results/0926/hog1dSymbols/sampled-sequences-hybridPts-length-52-stride-25-HOG1D-nblocks-2-nbins-8-xScale-0.10-activeAxis-Y-useGyro-0-K-20-symbols.mat';
anchorFile = '/lab/jiaping/projects/google-glass-project/results/0926/sampled-sequences-hybridPts-length-52-stride-25.mat';
rawTimeSeriesFile = '/lab/jiaping/projects/google-glass-project/data/glass-processed-data/cleandata.mat';

% symbolFile = '/lab/jiaping/projects/google-glass-project/results/0926/DTWMDSSymbols/sampled-sequences-atfeaturePts-length-52-useGyro-0-activeAxis-Y-centering-0-distDTW-MDSdescriptors-dims-5-K-20-symbols.mat';
% anchorFile = '/lab/jiaping/projects/google-glass-project/results/0926/sampled-sequences-atfeaturePts-length-52.mat';
% rawTimeSeriesFile = '/lab/jiaping/projects/google-glass-project/data/processed-data/cleandata.mat';




symboldata = load(symbolFile);
anchordata = load(anchorFile);
rawdata = load(rawTimeSeriesFile);

symbols         =   symboldata.symbols;
labels          =   rawdata.labels;
activityNames   =   rawdata.activityNames;
accelAnchorIdx  =   anchordata.accelAnchorIdx;
rawTimeSeries   =   rawdata.acceldata;


activityNames = {
    'drink-water'; ...
    'eat'; ...
    'open-close-door'; ...
    'pick-up-book'; ...
    'read'; ...
    'stand-still'; ...
    'take-elevator'; ...
    'walk-downStairs'; ...
    'walk-straight'; ...
    'walk-upStairs'; ...
    'write'};

nSamples = size(symbols,1);
depth    = 5;
MinLeaf  = 10;
nclasses = 20; %=K

resDir = '/lab/jiaping/projects/google-glass-project/results';

figureDir = strcat(resDir, '/0926/decomposeTree-20clusters-HOG1D-depth5-minleaf10');
if ~exist(figureDir, 'dir')
    mkdir(figureDir);
end

for i=1:nSamples
    i
    isymbols = symbols{i};
    ianchorIdx = accelAnchorIdx{i};
    iTimeSeries = rawTimeSeries{i}(:,2);
    t = genDecomposeTree(isymbols, nclasses, 'depth', depth, 'MinLeaf', MinLeaf);
    
    iterator = t.depthfirstiterator; 
    nNodes = max(iterator);
    
    if nNodes <= 1
        continue;
    end
    % setting 'timeseries' field of tree t
    for j=1:nNodes
        jt = t.get(j);
        temporalIdx = jt.temporalIdx;
        sidx = ianchorIdx(temporalIdx(1));
        eidx = ianchorIdx(temporalIdx(end));
        jt.timeseries = iTimeSeries(sidx:eidx);
        t = t.set(j, jt);
    end
    
    % get the plot configuration of each node in t
     anchorTree = genLayoutDecomposedTree(t);
     
    % plot decomopsed tree
    figure;  
%     set(gca, 'Position', [0 0 1 1]); 
    for j=1:nNodes
        pos = anchorTree.get(j);
        jt = t.get(j);
        jTimeSeries = jt.timeseries;
        jx =  1:length(jTimeSeries);
        jx = jx + round(pos(1)  - length(jTimeSeries)/2);
        jy = pos(2) + jTimeSeries - mean(jTimeSeries);
        plot(jx,jy, 'linewidth', 1, 'color', 'r');   
        hold on;
    end
    % plot edge
    for j=1:nNodes
        p = anchorTree.getparent(j);
        if p == 0
            continue;
        end
        jshift = anchorTree.get(j);
        pshift = anchorTree.get(p);
        plot([jshift(1) pshift(1)], [jshift(2) pshift(2)], 'linewidth', 2, 'color','b');
        hold on;        
    end
    set (gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);
    title(activityNames{labels(i)}, 'fontsize', 30);
    saveName = sprintf('%s/%s-%d.png', figureDir, activityNames{labels(i)},i);
    set(gca,    'xtick',[],'ytick',[] , 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
%     axis off;
    axis tight;
    export_fig(saveName, '-png', '-m1', gcf);
    close all;
    
    
    
end

