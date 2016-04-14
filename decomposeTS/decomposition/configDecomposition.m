
% configure decomposition setting

% (1) sampling setting
samplingSetting = struct('method', 'hybrid',...
                         'param', struct('sel', 5, ...
                                         'seqlen', 52, ...
                                         'stride', 25));
% samplingSetting = struct('method', 'hybrid',...
%                          'param', struct('sel', 30, ...
%                                          'seqlen', 62, ...
%                                          'stride', 2));
samplingSetting = validateSamplingSetting(samplingSetting);
seqlen = samplingSetting.param.seqlen;

% (2) descriptor setting
hog = validateHOG1Dparam;
hog.cells    = [1 round(seqlen/2)];
hog.overlap = 0;
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

% (3) clustering setting                       
K_kmeans = 10;                       
clust_method = 'kmeans';
clust_param = validateKMeansparam;
clust_param.nclusters = K_kmeans;

clusteringSetting = struct('method', 'kmeans', ...
                                       'param', clust_param);
clusteringSetting = validateClusteringSetting(clusteringSetting);

% (4) decomposition setting
splitModel = struct('criterion', 'entropy', ...
                    'nclasses', K_kmeans, ...
                    'dissimilarity', []);
splitModel = validateSplitModel(splitModel);

decomposeTreeSetting = struct('depth', 6, ...
                              'minlen', 200, ...
                              'splitModel', splitModel);
                          
% (5) save setting                          
                       
% dataDir = 'F:\USC-winter-break\google-glass\data\glass-processed-data-more\Glass-prepared-data';
% dataFile = 'processed-data-yaccel.mat';
% saveDir = 'F:\USC-winter-break\google-glass\results\0123';

dataDir = '/lab/jiaping/projects/google-glass-project/data/glass-processed-data-more/Glass-prepared-data';
% dataDir = '/lab/jiaping/projects/google-glass-project/data/glass-processed-data-more/Glass-prepared-data';
dataFile = 'processed-data-yaccel.mat';
saveDir = '/lab/jiaping/projects/google-glass-project/results/googleglass-decomposition-entropy';


if ~exist(saveDir, 'dir')
    mkdir(saveDir);
end

if ispc
    slash = '\';
else
    slash = '/';
end

matfileExt = '.mat';

                                     