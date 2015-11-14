% run DTW and shapeDTW to align simulated pairs 
% configPath;
%% parameter settings
curveParam      =   validateSmoothCurveParam;
scaleRanges     =   [0.5 1];
stretchParam    =   validateStretchingParam;
seqlen          =   20; % subsequence length in shapeDTW

%% save info
global pathinfo;
saveDir = pathinfo.saveDirSimulation;
if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end    

%% dataset information
datasets    = getDatasetNamesUCRALL;
dataDir     = getDatasetsDirUCR;
nDatasets   = numel(datasets);

rorder = randperm(nDatasets);
for idxTest = 1:nDatasets
    testDataSetIdx = rorder(idxTest);    
    
    if exist(fullfile(saveDir, [datasets{testDataSetIdx} '.mat']), 'file')
        continue;
    end  
    
    fprintf(1, '%d/%d: dataset: %s\n', idxTest, nDatasets, datasets{testDataSetIdx});
    signal = readucr(testDataSetIdx, 'train', dataDir);
    ts = signal(:,2:end);
    nTS = size(ts,1);

    % do simulation
    fprintf(1, '%d/%d: simulating aligned pairs...\n', idxTest, nDatasets);
    simulated_ts = cell(size(ts,1),1);
    scales = zeros(size(ts));
    gtAlignments = cell(size(ts,1),1);
    for i=1:nTS
        iLen = length(ts(i,:));
        curveParam.len = iLen;
        % scaling
        curve = simulateSmoothCurve(curveParam);
        curve = scaledata(curve, scaleRanges(1), scaleRanges(2));
        curve = curve(:)';
        scales(i,:)      = curve;
        i_scaledTS       = curve .* ts(i,:);
        % stretching
        [simulateIdx, gtAlignments{i}] = stretchingTS(iLen, stretchParam);
        i_simulatesTS = i_scaledTS(simulateIdx);
        simulated_ts{i}  = zNormalizeTS(i_simulatesTS);
        ts(i,:) = zNormalizeTS(ts(i,:));
    end
 
    % do DTW and shapeDTW alignment
    fprintf(1, '%d/%d: run alignment by DTW and shapeDTW...\n', idxTest, nDatasets);
	alignErrors = zeros(nTS,2); %% mean absolute deivation
    parfor i=1:nTS
        p = ts(i,:);
        q = simulated_ts{i};
        p = p(:);
        q = q(:);

        [~, align_dtw] = DTWfast(p,q); % DTW alignment
        [~,~,~,align_shapeDTW]  = ...
                            shapeDTW(p,q, seqlen); % shapeDTW alignment
 
        align_gt        = gtAlignments{i};
        dist_dtw        = alignDistArea(align_gt, align_dtw) / length(p);
        dist_shapeDTW   =  alignDistArea(align_gt, align_shapeDTW) / length(p);

        alignErrors(i,:) = [dist_dtw dist_shapeDTW];

    end
    
    save(fullfile(saveDir, [datasets{testDataSetIdx} '.mat']), 'alignErrors');
    
end