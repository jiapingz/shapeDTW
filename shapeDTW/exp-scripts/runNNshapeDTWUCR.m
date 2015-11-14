function runNNshapeDTWUCR(dataDir, saveDir, seqlen, descriptorSetting, metricSetting)
% run shape-DTW on UCR datasets


    %% validate parameter settings
	if ~exist('seqlen', 'var') || isempty(seqlen)
        seqlen = 20;
    end
    
    if ~exist('metricSetting', 'var') || isempty(metricSetting)
        metricSetting = 'Euclidean';
    end

    if ~exist('descriptorSetting', 'var') || isempty(descriptorSetting)
       %% using different shape descriptors      
        
        % ===== hog ===================
        hog = validateHOG1Dparam;
        hog.cells    = [1 round(seqlen/2)-1];
        hog.overlap  = 0; %round(seqlen/4);
        hog.xscale   = 0.1;

        % ===== paa ===================
        paa = validatePAAdescriptorparam;
        paa.priority = 'segNum';
        segNum = ceil(seqlen/5);
        paa.segNum = segNum;

        % ===== dwt ==================
        numLevels = 3;
        dwt = validateDWTdescriptorparam;
        dwt.numLevels = numLevels;

        % ===== raw-subsequence ===============
        self = [];
     
        % ===== default shape descriptor: raw-subsequence ============
        descriptorSetting = struct('method', 'self', ...
                                     'param', self);
% 
%         descriptorSetting = struct('method', 'HOG1D', ...
%                                    'param', hog);
    end


    UCRdatasets = getDatasetNamesUCRALL;
    nDatasets = numel(UCRdatasets);


    rng('shuffle');
    ridx = randperm(nDatasets);

    for i=1:nDatasets

        showIdx = ridx(i);        
        if exist(fullfile(saveDir, [UCRdatasets{showIdx} '.txt']), 'file')
            continue;
        else
            fid = fopen(fullfile(saveDir, [UCRdatasets{showIdx} '.txt']), 'wt');
            fprintf(fid, '1');
            fclose(fid);
        end
        fprintf(1,'Processing: %s ...\n', UCRdatasets{showIdx});
        
        % read data from disk
       %% train        
        if numel(descriptorSetting) == 1
            descriptorName = descriptorSetting.method; 
            descriptorParam = descriptorSetting.param;
        else
            descriptorName = descriptorSetting{showIdx}.method; 
            descriptorParam = descriptorSetting{showIdx}.param;
        end

        signals         = readucr(showIdx, 'train', dataDir);
        labelsTrain     = signals(:,1);
        nTrain          = length(labelsTrain);

        un_dataTrain    = signals(:,2:end);
        n_dataTrain     = zeros(size(un_dataTrain));    
        n_dTraincell    = cell(nTrain,1); % descriptor sequence

        fprintf(1, 'calculate descriptor of train data...\n');
       %% z-normalization  & calculate descriptor 
        parfor j=1:nTrain
            fprintf(1, '%d/%d\n', j, nTrain);
            jTrain = un_dataTrain(j,:);

            % normalization & sampling
            jTrain = zNormalizeTS(jTrain);
            n_dataTrain(j,:) = jTrain;
            j_subsequences = samplingSequencesIdx(jTrain(:), seqlen, 1:length(jTrain));  

            % calculate descriptors
            j_nsubsequences = numel(j_subsequences);
            j_descriptors   = cell(j_nsubsequences,1);
            for k=1:j_nsubsequences
                seq = j_subsequences{k};
                j_descriptors{k} = calcDescriptor(seq, descriptorName, descriptorParam);
            end
            j_descriptors = cell2mat(j_descriptors);
            n_dTraincell{j} = j_descriptors;
        end
        n_dataTraincell = mat2cell(n_dataTrain, ones(1,nTrain),size(n_dataTrain,2)); 


        %% test
        signals = readucr(showIdx, 'test', dataDir);
        labelsTest = signals(:,1);
        nTest = length(labelsTest);

        un_dataTest     = signals(:,2:end);
        n_dataTest      = zeros(size(un_dataTest));
        n_dTestcell     = cell(nTest,1);

        % z-normalization & calculate descriptors
        fprintf(1, 'calculate descriptors of test data...\n');
        for j=1:nTest
            fprintf(1, '%d/%d\n', j, nTest);
            jTest = un_dataTest(j,:);

            % normalization & sampling
            jTest = zNormalizeTS(jTest);
            n_dataTest(j,:) = jTest;        
            j_subsequences = samplingSequencesIdx(jTest(:), seqlen, 1:length(jTest));  

            % calculate descriptors
            j_nsubsequences = numel(j_subsequences);
            j_descriptors   = cell(j_nsubsequences,1);
            for k=1:j_nsubsequences
                seq = j_subsequences{k};
                j_descriptors{k} = calcDescriptor(seq, descriptorName, descriptorParam);
            end
            j_descriptors = cell2mat(j_descriptors);
            n_dTestcell{j} = j_descriptors;
        end

       %% run shape DTW    
        n_predLabelsRaw         = zeros(size(labelsTest));
        n_predLabelsDescriptor  = zeros(size(labelsTest));

        fprintf(1, 'running shapeDTW\n');
        parfor j=1:nTest
            [NNidxRaw, NNidxDescriptor] = ...
                NNshapeDTW2(n_dataTraincell, n_dataTest(j,:), n_dTraincell, n_dTestcell{j}, metricSetting);
            n_predLabelsRaw(j)          = labelsTrain(NNidxRaw);
            n_predLabelsDescriptor(j)   = labelsTrain(NNidxDescriptor);

        end

        n_AccuraciesRaw        = sum(n_predLabelsRaw == labelsTest)/nTest;
        n_AccuraciesDescriptor = sum(n_predLabelsDescriptor == labelsTest)/nTest;

        save(fullfile(saveDir, [UCRdatasets{showIdx} '.mat']), ...
                    'n_AccuraciesRaw', 'n_predLabelsRaw', ...
                    'n_AccuraciesDescriptor', 'n_predLabelsDescriptor', 'labelsTest');


    end
end