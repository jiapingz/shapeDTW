function signal = readucr(datasetIdx, trot, dataDir)
% inputs
%        idx - dataset index
%        trot - 'train' or 'test'
    narginchk(0,3);
	global datasetsDir;
 
    if nargin == 0
        datasetIdx = 1;
        trot = 'train';
     elseif nargin == 1
        trot = 'train';
     end
    
    if isempty(datasetIdx)
        datasetIdx = 1;
    end
    if ~exist('dataDir', 'var') || isempty(dataDir)
        dataDir = getDatasetsDirUCR;
    end
    datasetNames = getDatasetNamesUCRALL;
    nDatasets = numel(datasetNames);
    
    if datasetIdx > nDatasets || datasetIdx < 1
        fprintf(1, 'Please input a valid idx between [1 %d]\n', nDatasets);
    end

    
    fileName = strcat(datasetNames{datasetIdx}, ['_' upper(trot)]); 
    fileName_mat = strcat(datasetNames{datasetIdx}, ['_' upper(trot) '.mat']); 
    if exist(fullfile(dataDir, datasetNames{datasetIdx},  fileName), 'file')
        signal = load(fullfile(dataDir, datasetNames{datasetIdx},  fileName));
    elseif exist(fullfile(dataDir, datasetNames{datasetIdx},  fileName_mat), 'file')
        signal = load(fullfile(dataDir, datasetNames{datasetIdx},  fileName_mat));
        fNames = fieldnames(signal);
        signal = getfield(signal, fNames{1});
    else
        pStr = sprintf('Please download UCR datasets and place them into folder: %s', datasetsDir);
        fprintf(1, '%s\n', pStr);
        signal = [];
    end
 
end