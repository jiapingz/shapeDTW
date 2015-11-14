
%% (1) shape shapeDTW under different shape descriptors: 86 datasets
	seqlen = 30;
	segNum = ceil(seqlen/5);
    numLevels = 3;    
    
    % (2) descriptor setting              
    hog = validateHOG1Dparam;
    hog.cells    = [1 round(seqlen/2)];
    hog.overlap  = 0;
    hog.xscale   = 0.1;   
 
    paa = validatePAAdescriptorparam;
    paa.priority = 'segNum';
    paa.segNum = segNum; 

    dwt = validateDWTdescriptorparam;
    dwt.numLevels = numLevels;

	hogdwt = validateHOG1DDWTdescriptorparam;
    hogdwt.HOG1D = hog;
    hogdwt.DWT = dwt;    
	
	self = [];
    
    %% ========= default, run two shape descriptors =================
	descriptorsSetting = struct('method', {'self', 'HOG1D'}, ...
                                'param',  { self, hog});
    metricsSetting     = {'Euclidean',  'Euclidean'};
    %% ==============================================================

        
    %% ========= if you want to run shapeDTW under all shape descriptors
    %% ========= uncomment the following lines
% 	descriptorsSetting = struct('method', {'self', 'HOG1D', 'PAA', 'DWT', 'HOG1DDWT'}, ...
%                                 'param',  { self, hog, paa, dwt, hogdwt});
%	metricsSetting = {'Euclidean',  'Euclidean','Euclidean',  'Euclidean','Euclidean'};
    %% =================================================================
    
%% (2) set save directory    
    global pathinfo;
    saveDir =  pathinfo.saveDirNNshapeDTW;
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end
    
%% (3) run NN-shapeDTW under different shape descriptors    
    nDescriptors = numel(descriptorsSetting);
    for d=1:nDescriptors
        dataDir = getDatasetsDirUCR;
        d_saveDir = fullfile(saveDir, descriptorsSetting(d).method);
        if ~exist(d_saveDir, 'dir')
            mkdir(d_saveDir);
        end
        runNNshapeDTWUCR(dataDir, d_saveDir, ...
                    seqlen, descriptorsSetting(d), metricsSetting{d})
    end
