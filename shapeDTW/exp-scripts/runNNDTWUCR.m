function runNNDTWUCR(dataDir, saveDir)
% run NNDTW on UCR datasets

    UCRdatasets = getDatasetNamesUCRALL;
    nDatasets   = numel(UCRdatasets);


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
        signals          = readucr(showIdx, 'train', dataDir);
        labelsTrain      = signals(:,1);
        nTrain           = length(labelsTrain);
        un_dataTrain     = signals(:,2:end);
        n_dataTraincell  = cell(nTrain,1);
         % z-normalization  
        for j=1:nTrain
            fprintf(1, '%d/%d\n', j, nTrain);
            jTrain = un_dataTrain(j,:);
            jTrain = zNormalizeTS(jTrain);
            n_dataTraincell{j} = jTrain';
        end

        %% test
        signals         = readucr(showIdx, 'test', dataDir);
        labelsTest      = signals(:,1);
        un_dataTest   	= signals(:,2:end);
        n_dataTest      = zeros(size(un_dataTest));
        nTest           = length(labelsTest);
         % z-normalization  
         for j=1:nTest
            fprintf(1, '%d/%d\n', j, nTest);
            jTest = un_dataTest(j,:);
            jTest = zNormalizeTS(jTest);
            n_dataTest(j,:) = jTest;
        end

        %% run shape DTW    
        n_predLabels = zeros(size(labelsTest));
        fprintf(1, 'running NNDTW\n');
        parfor j=1:nTest
            [NNidx, dists] = NNDTW2(n_dataTraincell, n_dataTest(j,:)');
            n_predLabels(j) = labelsTrain(NNidx)
        end
        n_Accuracies = sum(n_predLabels == labelsTest)/nTest;

        save(fullfile(saveDir, [UCRdatasets{showIdx} '.mat']), ...
                   'n_Accuracies', 'n_predLabels', 'labelsTest');


    end
end