% test temporal pyramid representation of time series

% symbolize time series using a set of local descriptors
% there are several steps involved:
% (1) sampling from raw time series data, to get subsequences;
% (2) extract hog1d features from each subsequence;
% (3) k-means clustering to get visual words;
% (4) assign each subsequence to one word, and finally a sequence of words
% represent the raw time series

init;
load(strcat(dataDir, '/cleandata.mat'));
saveDir = strcat(resDir, '/1007');
if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

%% (1) sampling
seqlen = 52;
stride = 25;
sampling_method = 'hybrid';
% sampling_method = 'featurePts';

seqsFileName = ...
                generateSeqFileName(sampling_method, seqlen, stride);  
if exist(strcat(saveDir, '/', seqsFileName), 'file')
    load(strcat(saveDir, '/', seqsFileName));
else
    fprintf(1, 'Sampling time series to get subsequences...\n');
    switch sampling_method
        case 'hybrid'
            [gyroSequences, accelSequences, gyroAnchorIdx, accelAnchorIdx] ...
                                    = doSamplingHybridPts(gyrodata, acceldata, seqlen, stride);
        case 'featurePts'
            [gyroSequences, accelSequences, gyroAnchorIdx, accelAnchorIdx] ...
                                    = doSamplingFePts(gyrodata, acceldata, seqlen);
        case 'evently'
            [gyroSequences, accelSequences, gyroAnchorIdx, accelAnchorIdx] = ...
                                doSamplingEvenly(gyrodata, acceldata, seqlen, stride);
        otherwise
            error('Please specify a sampling strategy\n');
            
    end
    save(strcat(saveDir,'/', seqsFileName), 'gyroSequences', 'accelSequences', ...
                                'gyroAnchorIdx', 'accelAnchorIdx', 'labels', 'activityNames');
end        


%% (2.1) HOG1D extraction
hogDir = strcat(saveDir, '/hog1d');
if ~exist(hogDir, 'dir')
    mkdir(hogDir);
end
activeAxis = {'Y'};
strActiveAxis = '';
for a=1:size(activeAxis,2)
    str1 = strcat(strActiveAxis, activeAxis{a});
    strActiveAxis = str1;
end
hog1d_param = validateHOG1Dparam;
%{
    val_param.blocks    = [1 2];  % unit: cell
    val_param.cells     = [1 25]; % unit: t
    val_param.gradmethod = 'centered'; % 'centered'
    val_param.nbins = 8;
    val_param.sign = 'true';
    val_param.xscale = 0.1;
    val_param.cutoff = [2 51];
    val_param.sign = 'true';
%}
hog1dFileName = validateHOG1DFileName(sampling_method, seqlen, stride, ...
                                                    hog1d_param, strActiveAxis);
                                                
if exist(strcat(hogDir, '/', hog1dFileName), 'file')
    load(strcat(hogDir, '/', hog1dFileName));
else
    fprintf(1, 'extracting HOG1D features...\n');
	[accelHog1d, gyroHog1d] = doFeExtractHOG1D(accelSequences, gyroSequences, hog1d_param, activeAxis);
    save(strcat(hogDir, '/', hog1dFileName), 'accelHog1d', 'gyroHog1d', 'activityNames', 'labels'); 
end

        
%% (3.1) k-means clustering
useGyro = 0;
K = 50;
symbolFileName = validateHOG1DSymbolFileName(sampling_method, seqlen, stride, ...
                                                    hog1d_param, strActiveAxis, useGyro, K);
hogSymbolDir = strcat(saveDir, '/', 'hog1dSymbols');  
if ~exist(hogSymbolDir, 'dir')
    mkdir(hogSymbolDir);
end
if useGyro == 0
    subsequences = accelHog1d;
    fprintf(1, 'symbolization...\n');
    
    while 1
        nSamples = numel(subsequences);
        nTrain = round(0.6*nSamples);
        nTest = nSamples - nTrain;
        rng('shuffle');
        randidx     = randperm(nSamples);
        idxTrain    = randidx(1:nTrain);
        idxTest     = randidx(nTrain + 1:end);
        seqTrain    = subsequences(idxTrain);
        seqTest     = subsequences(idxTest);
        labelsTrain = labels(idxTrain);
        labelsTest  = labels(idxTest);
        if length(unique(labelsTrain)) ~= length(unique(labels))
            continue;
        else 
            break;
        end
    end
    [symbolsTrain, symbolsTest]= symbolizationKMeans2(seqTrain, seqTest, K);
    
    save(strcat(hogSymbolDir, '/', symbolFileName), 'symbolsTrain', 'symbolsTest', 'activityNames', ...
                                                        'labelsTrain', 'labelsTest'); 

else
end


%% (4) compare different ways of encoding

% 4.1 bow encoding
% (4) ======== SVM classifier ==============================     

    bowTrain = [];
    for i=1:nTrain
        bowTrain = cat(1, bowTrain, bowEncoderPyramid(symbolsTrain{i}, K, 0));
    end
    
    bowTest = [];
    for i=1:nTest
         bowTest = cat(1, bowTest, bowEncoderPyramid(symbolsTest{i}, K, 0));
    end

    nbowTrain = bowTrain./repmat(sqrt(sum(bowTrain.^2,2)),1,K);
    nbowTest = bowTest./repmat(sqrt(sum(bowTest.^2,2)),1,K);
    model = svmtrain(labelsTrain, bowTrain,  '-t 2 -c 10');
    [predict_label, accuracy, dec_values] = svmpredict(labelsTest, bowTest, model); 


    % power transformation
    acc_bow = [];
    cnt = 1;
     for i=0.1:0.1:1
            model = svmtrain(labelsTrain,  bowTrain.^i ,  '-t 2 -c 10');
            [predict_label, accuracy, dec_values] = svmpredict(labelsTest, bowTest.^i , model); 
            acc_bow(cnt) = accuracy(1);
            cnt = cnt +1;
     end
    
     plotCM(labelsTest, predict_label, activityNames);
    
% 4.2 temporal pyramid bow encoding

    bowTrain = [];
    for i=1:nTrain
        bowTrain = cat(1, bowTrain, bowEncoderPyramid(symbolsTrain{i}, K, 2));
    end
    
    bowTest = [];
    for i=1:nTest
         bowTest = cat(1, bowTest, bowEncoderPyramid(symbolsTest{i}, K, 2));
    end

%     nbowTrain = bowTrain./repmat(sqrt(sum(bowTrain.^2,2)),1,K);
%     nbowTest = bowTest./repmat(sqrt(sum(bowTest.^2,2)),1,K);
%     model = svmtrain(labelsTrain, bowTrain,  '-t 2 -c 10');
%     [predict_label, accuracy, dec_values] = svmpredict(labelsTest, bowTest, model); 


    % power transformation
    acc_bowPyramid = [];
    cnt = 1;
     for i=0.1:0.1:1
            model = svmtrain(labelsTrain,  bowTrain.^i ,  '-t 2 -c 10');
            [predict_label, accuracy, dec_values] = svmpredict(labelsTest, bowTest.^i , model); 
            acc_bowPyramid(cnt) = accuracy(1);
            cnt = cnt +1;
     end

    plotCM(labelsTest, predict_label, activityNames);






