
%%  run cross-validate to get the smooth parameter for each data set
 
datasets    = getDatasetNamesUCRALL;
nDatasets   = numel(datasets);

% smooth parameter candidates
sParam = struct('span', {3,5,7,9,11,13}, ...
                'method', 'moving');
nSpans = numel(sParam);
nfolders = 5; % 5-folder cross-validation

% data directory
global pathinfo;
dataDir  = getDatasetsDirUCR;
saveDir = pathinfo.saveDirNNsmoothedDTW;

rng('shuffle');
rorder = randperm(nDatasets);

for dd=1:nDatasets
    d = rorder(dd);
	subsaveDir = fullfile(saveDir,  datasets{d});
    if ~exist(subsaveDir, 'dir')
        mkdir(subsaveDir);
    end
    if exist(fullfile(subsaveDir, 'done.txt'), 'file')
        continue;
    else
        fid = fopen(fullfile(subsaveDir, 'done.txt'), 'wt');
        fprintf(fid, '1\n');
        fclose(fid);
    end
    
    
    fprintf(1, 'Processing dataset %d/%d: %s...\n', d, nDatasets, datasets{d});    
    %% train
    signals          = readucr(d, 'train', dataDir);
    labelsTrain      = signals(:,1);
    nTrain           = length(labelsTrain);
    un_dataTrain     = signals(:,2:end);
    n_dataTraincell  = cell(nTrain,1);
     % z-normalization  
    parfor j=1:nTrain
        fprintf(1, '%d/%d\n', j, nTrain);
        jTrain = un_dataTrain(j,:);

        jTrain = zNormalizeTS(jTrain);
        n_dataTraincell{j} = jTrain';
    end
    dataTrain  = n_dataTraincell;

   %% ========== test =================
    signals         = readucr(d, 'test', dataDir);
    labelsTest      = signals(:,1);
    un_dataTest   	= signals(:,2:end);
    nTest           = length(labelsTest);
    n_dataTestcell  = cell(nTest,1);
     % z-normalization  
     parfor j=1:nTest
        fprintf(1, '%d/%d\n', j, nTest);
        jTest = un_dataTest(j,:);
        jTest = zNormalizeTS(jTest);
        n_dataTestcell{j} = jTest';
     end
    dataTest = n_dataTestcell;
     
    %% (1) cross validation to get the smooth parameters
    fprintf(1, 'Cross validation...\n');
	partitions = CVsplit2folders(labelsTrain, nfolders);

    s_acc = zeros(1,nSpans);
	for s=1:nSpans
        fprintf(1, 'Cross validation %d/%d\n', s, nSpans);
        s_param = sParam(s);        
        acc = zeros(1,size(partitions,2));
        for f=1:size(partitions,2)
            f_test  = partitions(:,f);
            f_train = ~partitions(:,f);
            f_traindata     = dataTrain(f_train);
            f_testdata      = dataTrain(f_test);
            f_trainlabels   = labelsTrain(f_train);
            f_testlabels    = labelsTrain(f_test);
            
            f_testPred = zeros(size(f_testlabels));
            
            parfor t=1:numel(f_testlabels)
            
                NNidx = sNNDTW(f_traindata, f_testdata{t}, s_param);
                f_testPred(t) = f_trainlabels(NNidx);
            end
            
            acc(f) = sum(f_testPred == f_testlabels)/numel(f_testlabels);
            
        end
        s_acc(s) = mean(acc);        
    end
    
    [~,s_idx] = max(s_acc);
    smoothParam = sParam(s_idx);
    
    %% (2) using that smoothing parameter, to smooth both training 
    %% and test data, and then run NNDTW
    fprintf(1, 'NNDTW to predict test labels...\n');
    labelsPred = zeros(size(labelsTest));
	parfor t=1:numel(labelsTest)
        NNidx = sNNDTW(dataTrain, dataTest{t}, smoothParam);
        labelsPred(t) = labelsTrain(NNidx);
    end
    acc = sum(labelsPred == labelsTest)/numel(labelsTest);      
    save(fullfile(subsaveDir, 'acc.mat'), 's_acc', 'acc'); 
end

