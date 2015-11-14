% demo of shape Dynamic Time Warping (shapeDTW)

% configPath;
%% (1) read data
dataDir      = getDatasetsDirUCR;
datasetsName = getDatasetNamesUCRALL;
nDatasets    = numel(datasetsName);

datasetIdx = 4; % { 6, 21,23, 27, 51, 66}
fprintf(1, 'processing dataset: %s...\n', datasetsName{datasetIdx});
ts = readucr(datasetIdx, 'train', dataDir);
nInstances = size(ts,1);
ts_data    = ts(:,2:end);
ts_labels  = ts(:,1);
 

seqlen = 20; % subsequence length
nExp = 5;    % # of experiments

%% (2) run alignment
for i=1:nExp
    p = ts_data(randi(nInstances),:);
    q = ts_data(randi(nInstances),:);
    
    np = zNormalizeTS(p);
    nq = zNormalizeTS(q);
    %% run shapeDTW
    [~,~,~,align_shapeDTW]  = shapeDTW(np(:),nq(:), seqlen);
    plotElasticMatching(np, nq, align_shapeDTW);
    title('shapeDTW');

    %% run traditional DTW
    [~, align_dtw] = DTWfast(np(:), nq(:));
    plotElasticMatching(np, nq, align_dtw);
    title('DTW');
end