
% decomposition time series into segments
% step 1: kmeans to get clustering centers
% step 2: symbolization
% step 3: visualization

configDecomposition;
data_read     = load(strcat(dataDir, slash, dataFile));

sensordata    = data_read.data;
activityNames = data_read.activityNames;
labels        = data_read.labels;

% step 1: kmeans to get clustering centers

% 1.1 sampling
samplingMethod = samplingSetting.method;
seqlen = samplingSetting.param.seqlen;
stride = samplingSetting.param.stride;
sel    = samplingSetting.param.sel;
samplingFileName = generateSeqFileName(samplingMethod, seqlen, stride, sel);
if ~exist(strcat(saveDir, slash , [samplingFileName matfileExt]), 'file')
    [subsequences, subsequencesIdx] = ...
                    runSamplingTSbatch(sensordata, samplingMethod, sel, seqlen, stride);
    save(strcat(saveDir, slash,  [samplingFileName matfileExt]), 'subsequences', 'subsequencesIdx', 'labels' );
else
    load(strcat(saveDir, slash,  [samplingFileName matfileExt]));
end    

% 1.2 descriptor computation
descriptorName = descriptorSetting.method;
descriptorParam = descriptorSetting.param;
tmpDescriptorFileName = ...
            generateDescriptorFileName(descriptorName, descriptorParam);

descriptorFileName = genDescriptorFileName(samplingFileName, tmpDescriptorFileName);

 if ~exist(strcat(saveDir, slash, [descriptorFileName matfileExt]), 'file')
    descriptors = calcDescriptorsTSbatch(subsequences, descriptorName, descriptorParam);
    save(strcat(saveDir, slash, [descriptorFileName matfileExt]), ...
                'subsequences', 'subsequencesIdx', 'descriptors',  'labels' );                 
 else
     load(strcat(saveDir, slash, [descriptorFileName matfileExt]));
 end
 
 % 1.3 k-means to get clustering centers 
 descriptors = extractDimensionASynMTS(descriptors, 1); 
 descriptorsMat = [];
 for i=1:numel(descriptors)
     descriptorsMat = cat(1, descriptorsMat, cell2mat(descriptors{i})); 
 end    
 if size(descriptorsMat,1) < 3*K_kmeans
    return;
 end
 fprintf(1,'K-means to get the vocabulary\n');
 [Idx2Centers,Centers] = ...
     kmeans(descriptorsMat, K_kmeans, 'emptyaction','singleton', 'replicates', 1);

 
 seqlen = samplingSetting.param.seqlen;
 raw_subsequences = [];
 subsequences = extractDimensionASynMTS(subsequences,1);
 for i=1:numel(subsequences)
     nSubsequences = numel(subsequences{i});
     raw_subsequences = cat(2, raw_subsequences, ...
                reshape(cell2mat(subsequences{i}), seqlen, nSubsequences));
 end
 raw_subsequences = raw_subsequences';
 
 mean_shapelets = zeros(K_kmeans, seqlen);
 subsequences_set = cell(K_kmeans,1);
 for i=1:K_kmeans
     i_idx = Idx2Centers == i;
     i_raw_subsequences = raw_subsequences(i_idx,:);
     mean_shapelets(i,:) = mean(i_raw_subsequences);
     cnt = size(i_raw_subsequences,1);
     subsequences_set{i} = mat2cell(reshape(i_raw_subsequences', seqlen*cnt,1), seqlen*ones(cnt,1));
 end
 
 % Method 1: use dynamic time warping to get the difference between clusters
 dissimilarity_DTW = zeros(K_kmeans, K_kmeans);
 for i=1:K_kmeans
     for j=i+1:K_kmeans
         dissimilarity_DTW(i,j) = dDTWsets(subsequences_set{i}, ...
                                    subsequences_set{j});
     end
 end
 dissimilarity_DTW = dissimilarity_DTW + dissimilarity_DTW';
 
 % Method 3: use mean dynimic time warping to get the difference between
  dissimilarity_meShapelets = zeros(K_kmeans, K_kmeans);
  for i=1:K_kmeans
      for j=i+1:K_kmeans
          dissimilarity_meShapelets(i,j) = dtw_c(mean_shapelets(i,:)', ...
                                mean_shapelets(j,:)');
      end
  end
 dissimilarity_meShapelets = dissimilarity_meShapelets + dissimilarity_meShapelets';

 % Method 2: use descriptors to get the difference
 dissimilarity = zeros(K_kmeans, K_kmeans);
 for i=1:K_kmeans
     c1 = Centers(i,:);
     for j=i+1:K_kmeans
         c2 = Centers(j,:);
         dissimilarity(i,j) = norm(c1-c2,2);
     end
 end
 dissimilarity = dissimilarity + dissimilarity';
 
 decomposeTreeSetting.splitModel = struct('criterion', 'entropy', ...
                                          'nclasses', K_kmeans, ...
                                          'dissimilarity', dissimilarity);
 
 % step 2: symbolization & visualization
 xticklabel = {};
 for i=1:K_kmeans
     xticklabel = cat(1, xticklabel, num2str(i));
 end
 nSamples = numel(sensordata);
 subSaveDir = strcat(saveDir, slash, sprintf('%s-%s-K%d', ...
          splitModel.criterion, descriptorSetting.method, K_kmeans));
 if ~exist(subSaveDir, 'dir')
     mkdir(subSaveDir);
 end
 for i=1:nSamples
    
     saveName = sprintf('%s-%d', strcat(subSaveDir, slash, activityNames{labels(i)}),i);
     if exist(saveName, 'file')
         continue;
     end

     TS = sensordata{i}{1};
    [symbols, subsequencesIdx, markers] =  ...
      symbolizeTS(TS, samplingSetting, descriptorSetting, Centers);
    
%     figure;
%     set (gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);
%     N = hist(symbols(markers ~= 0), 1:50);
%     peak    =   hist(symbols(markers == 1), 1:50);
%     valley  =   hist(symbols(markers == -1), 1:50);
%     bar([peak' valley']);
%     set(gca, 'xtick', 1:50, 'xticklabel', xticklabel);
%     xlim([0 52]);
%     title(activityNames{labels(i)}, 'fontsize', 30);
%  	export_fig(saveName, '-png', '-m1', gcf);
%     close all; 
     
  
    t = buildDecomposeTree(TS, subsequencesIdx, markers, ...
                                            symbols, decomposeTreeSetting);
    plotDecomposedTree(t);    
    
	title(activityNames{labels(i)}, 'fontsize', 30);
 	export_fig(saveName, '-png', '-m1', gcf);
    close all; 
  
 end
 
 
 
 
 