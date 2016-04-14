% symbolize time series using a set of local descriptors
% there are several steps involved:
% (1) sampling from raw time series data, to get subsequences;
% (2) extract hog1d features from each subsequence;
% (3) k-means clustering to get visual words;
% (4) assign each subsequence to one word, and finally a sequence of words
% represent the raw time series

init;
load(strcat(dataDir, '/cleandata.mat'));
saveDir = strcat(resDir, '/0926');
if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

%% (1) sampling
seqlen = 52;
stride = 25;
% sampling_method = 'hybrid';
sampling_method = 'featurePts';

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


%% (2.2) DTW-MDS descriptor extraction
useGyro     = 0;
activeAxis  = {'Y'};
isCentering = 0;
DTWMDSdims = 5;
dDTWfileName = ...
                validateDTWdistFileName(sampling_method, seqlen, stride, useGyro, activeAxis, isCentering);

descDTWMDSfile = validateDTWMDSfileName(dDTWfileName, DTWMDSdims);
if ~exist(strcat(saveDir,'/', descDTWMDSfile), 'file')
    fprintf(1, sprintf('MDS to get low dimensional descriptors -- dims-%d...\n', DTWMDSdims));
    tic;
    [MDSdescriptors,~] = mdscale(squareform(dDTW),DTWMDSdims);
    toc;
    t = toc;
    fprintf(1, 'saving descriptors...\n');
    save(strcat(workDir, '/', descDTWMDSfile), 'sequencesdata', 'labels', 'activityNames', 'idx', 'MDSdescriptors', 't', '-v7.3');
    clear MDSdescriptors;
    clear dDTW idx sequencesdata;            
else
    load(strcat(saveDir, '/', descDTWMDSfile));
end
        
    
%% (3.2) k-means clustering
K = 50;
symbolFileName = validateDTWMDSSymbolFileName(descDTWMDSfile, K);
DTWMDSSymbolDir = strcat(saveDir, '/', 'DTWMDSSymbols');  
if ~exist(DTWMDSSymbolDir, 'dir')
    mkdir(DTWMDSSymbolDir);
end

nsubsequences = zeros(length(idx),1);
for i=1:length(idx)
    nsubsequences(i) = length(idx{i});
end
subsequences = mat2cell(MDSdescriptors, nsubsequences);
fprintf(1, 'symbolization from DTWMDS descriptors...\n');
symbols= symbolizationKMeans(subsequences, K);
save(strcat(DTWMDSSymbolDir, '/', symbolFileName), 'symbols', 'activityNames', 'labels'); 


            
%% (3.1) k-means clustering
useGyro = 0;
K = 20;
symbolFileName = validateHOG1DSymbolFileName(sampling_method, seqlen, stride, ...
                                                    hog1d_param, strActiveAxis, useGyro, K);
hogSymbolDir = strcat(saveDir, '/', 'hog1dSymbols');  
if ~exist(hogSymbolDir, 'dir')
    mkdir(hogSymbolDir);
end
if useGyro == 0
    subsequences = accelHog1d;
    fprintf(1, 'symbolization...\n');
    symbols= symbolizationKMeans(subsequences, K);
    save(strcat(hogSymbolDir, '/', symbolFileName), 'symbols', 'activityNames', 'labels'); 

else
end


                                                
    
