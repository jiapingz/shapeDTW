% simulate aligned sequence-pairs

% configPath;
%% (1) read data
dataDir      = getDatasetsDirUCR;
datasetsName = getDatasetNamesUCRALL;
nDatasets    = numel(datasetsName);

datasetIdx = 3; % {4, 30} 
fprintf(1, 'processing dataset: %s...\n', datasetsName{datasetIdx});
ts      = readucr(datasetIdx, 'train', dataDir);
ts      = ts(:,2:end);
nTS     = size(ts,1);

% do simulation
scaleParam      = validateSmoothCurveParam; % scale simulation parameter
scaleRanges     = [0.4 1];                  % scale ranges
stretchParam    = validateStretchingParam;  % stretching parameter
nExp = 5;

seqlen = 20;
for i=1:nExp
    iTS = ts(randi(nTS),:);
    ts_len = length(iTS);
    scaleParam.len = ts_len;
    
    % scaling
    scale = simulateSmoothCurve(scaleParam);
    scale = scaledata(scale, scaleRanges(1), scaleRanges(2));
    scale = scale(:)';
    scaledTS       = scale .* iTS;
    % stretching
    [simulateIdx, align_GT] = stretchingTS(ts_len, stretchParam);
    simulatedTS = scaledTS(simulateIdx);

    % normalization
    p = zNormalizeTS(iTS);
    q = zNormalizeTS(simulatedTS);
    
    figure; 
    subplot(121);
    plot(scale, 'linewidth', 3, 'color', 'r'); title('simulated scale'); 
    axis tight;
    subplot(122);
    plot(p, 'linewidth',3, 'color', 'k'); hold on; 
    plot(q, 'linewidth',3, 'color', 'b'); 
    legend({'original', 'simulated'});
    axis tight;
    title('simulation');
    
    %% plot ground-truth  alignment
    plotElasticMatching(p,q, align_GT);
    title('ground truth alignment');    
    
    %% run shapeDTW
    [~,~,~,align_shapeDTW]  = shapeDTW(p(:),q(:), seqlen);
    plotElasticMatching(p,q, align_shapeDTW);
    title('shapeDTW');

    %% run traditional DTW
    [~, align_dtw] = DTWfast(p(:),q(:));
    plotElasticMatching(p,q, align_dtw);
    title('DTW');
    
    %% compute alignment errors
    % shapeDTW 
    error_shapeDTW = alignDistArea(align_GT, align_shapeDTW);
    % DTW
    error_DTW = alignDistArea(align_GT, align_dtw);
    fprintf(1, 'alignment error: %d (shapeDTW), %d (DTW)\n', ...
                        error_shapeDTW, error_DTW);
    
    
end
 