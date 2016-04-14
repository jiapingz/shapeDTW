% decompose simulated curves

%% (1) decomposition parameter setting
	samplingSetting = struct('method', 'hybrid', ...
                             'param', struct('sel', 5, 'seqlen', 10, 'stride', 1));

    % sampling setting
    samplingSetting = validateSamplingSetting(samplingSetting);
    seqlen = samplingSetting.param.seqlen;
    % descriptor setting
    hog = validateHOG1Dparam;
    hog.cells    = [1 round(seqlen/2)-1];
    hog.overlap = 0; %round(seqlen/4);
    hog.xscale  = 0.1;

    paa = validatePAAdescriptorparam;
    paa.priority = 'segNum';
    segNum = ceil(seqlen/5);
    paa.segNum = segNum;

    numLevels = 3;
    dwt = validateDWTdescriptorparam;
    dwt.numLevels = numLevels;

    descriptorSetting = struct('method', 'HOG1D', ...
                                           'param', hog);

    
    % clustering setting
    clusteringSetting = struct('method', 'kmeans', ...
                                'param', struct('nclusters', 20, ...
                                                'EmptyAction', 'singleton', ...
                                                'MaxIter', 100));
    clusteringSetting = validateClusteringSetting(clusteringSetting);

    
    nclusters = clusteringSetting.param.nclusters;
    
    % decision tree setting
    splitModel = struct('criterion', 'entropy', ...
                        'nclasses', nclusters, ...
                        'dissimilarity', []);
    splitModel = validateSplitModel(splitModel);
    decomposeTreeSetting = struct('depth', 10, ...
                                   'minlen', 50, ...
                                   'splitModel', splitModel); 

                               
%% (2) decompse simulated simple curves
    saveDir = '/lab/ilab/30/jiaping-iccv/curve-simulations/decomposedTS/simulations-50-complex-noise';
    simulatedcurvesDir = '/lab/ilab/30/jiaping-iccv/curve-simulations/data/simulations-50-complex-noise';
    curveFiles = dir(strcat(simulatedcurvesDir, '/*.mat'));
    nCurves = numel(curveFiles);
    
    minLen = Inf;
    maxLen = 0;

    for i=1:nCurves
        curveInfo = loadMatFile(simulatedcurvesDir, curveFiles(i).name);
        curve = curveInfo.simInfo.curve;
        minLen = min(minLen, length(curve));
        maxLen = max(maxLen, length(curve));
    end
    
    gapK = 20;
%     Ks = [2:40 10:gapK:round(minLen/2)];
    Ks = [10:gapK:round(minLen/2) 1210:gapK:1350];
%     Ks = 1210:gapK:1800;
    nKs = numel(Ks);
    
    for c=1:nKs
        k = Ks(c);
        clusteringSetting.param.nclusters = k;
        
        fsubsaveDir = strcat(saveDir, '/', ['clusters-' num2str(k)]);
        if ~exist(fsubsaveDir, 'dir')
        	mkdir(fsubsaveDir);
        end
        for i=1:nCurves

            fprintf(1, 'cluters: %d; curve: %d\n', k, i);


            iCurveFileName = curveFiles(i).name;
            if exist(strcat(fsubsaveDir, '/', iCurveFileName), 'file')
                continue;
            end

             if exist(strcat(fsubsaveDir, '/', [iCurveFileName(1:end-4) '.flag']), 'file')
                 continue;
             else
                 fid = fopen(strcat(fsubsaveDir, '/', [iCurveFileName(1:end-4) '.flag']), 'w');
                 fprintf(fid, '1\n');
                 fclose(fid);
             end

            
            
            curveInfo = loadMatFile(simulatedcurvesDir, curveFiles(i).name);
            curve = curveInfo.simInfo.curve;
            simInfo = curveInfo.simInfo;
            decomposedTree = decomposeCurve(curve, samplingSetting, descriptorSetting, ...
                                     clusteringSetting, decomposeTreeSetting);
                                 
            tFile = genAbsMatFile(fsubsaveDir, iCurveFileName);
            save(tFile, 'decomposedTree', 'simInfo');
        end            
    end
    