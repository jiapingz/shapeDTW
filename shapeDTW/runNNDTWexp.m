%%  run NNDTW on 86 datasets
    global pathinfo;
    saveDir = pathinfo.saveDirNNDTW;
    if ~exist(saveDir, 'dir')
        mkdir(saveDir);
    end
    dataDir = getDatasetsDirUCR;
    runNNDTWUCR(dataDir, saveDir);  