
function runNNdeDTWUCR(dataDir, saveDir)
% derivative DTW distances
% calculate pairwise distances: (1) among training instances;
%                              (2) among training & testing instances
    narginchk(2,2);
    if ~exist('dataDir', 'dir') || isempty(dataDir)
        dataDir = getDatasetsDirUCR;
    end    

% (1) data directory 
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
       %% ====== train ===============
        signals          = readucr(showIdx, 'train', dataDir);
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
       
	   %% ========== test =================
        signals         = readucr(showIdx, 'test', dataDir);
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
         
        
        %% ========= distances between train and test instances        
        distTest2Train = zeros(nTest, nTrain);        
        for m=1:nTest
            mTest = n_dataTestcell{m};
            fprintf(1,'test2train: %d/%d\n', m, nTest);
            parfor k=1:nTrain
                kTrain = n_dataTraincell{k};
                [dDerivative, ~, ~] = deDTW(mTest, kTrain);                  
                distTest2Train(m,k) = dDerivative;
            end
        end
        
        [~, idx] = min(distTest2Train, [], 2);
        labelsPred = labelsTrain(idx);
        acc = sum(labelsPred == labelsTest)/numel(labelsTest);

        save(fullfile(saveDir, [UCRdatasets{showIdx} '.mat']), ...
                 'distTest2Train', 'labelsTrain', 'labelsTest', 'labelsPred', 'acc', '-v7.3' );

    end
end