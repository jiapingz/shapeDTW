
    configDecomposition;
    data_read     = load(strcat(dataDir, slash, dataFile));

	sensordata    = data_read.data;
    activityNames = data_read.activityNames;
    labels        = data_read.labels;



  decomposeTreeSetting.splitModel = struct('criterion', 'entropy', ...
                                          'nclasses', K_kmeans, ...
                                          'dissimilarity', []);
 
                                      
 % step 2: symbolization & visualization 
 nSamples = numel(sensordata);
 subSaveDir = strcat(saveDir, slash, sprintf('%s-%s-K%d', ...
          splitModel.criterion, descriptorSetting.method, K_kmeans));
 if ~exist(subSaveDir, 'dir')
     mkdir(subSaveDir);
 end
 for i=1:nSamples
    
     saveName = sprintf('%s-%d.png', strcat(subSaveDir, slash, activityNames{labels(i)}),i);
     if exist(saveName, 'file')
%          continue;
     end

    TS = sensordata{i}{1};
    [symbols, subsequencesIdx, markers] =  ...
      symbolizeTSindividually(TS, samplingSetting, descriptorSetting, clusteringSetting);
 
  
    t = buildDecomposeTree(TS, subsequencesIdx, markers, ...
                                            symbols, decomposeTreeSetting);
    plotDecomposedTree(t);        
	title(activityNames{labels(i)}, 'fontsize', 30);
%  	export_fig(saveName, '-png', '-m1', gcf);
    close all; 
  
 end