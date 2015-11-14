
global workDir;
workDir = pwd;
 
global pathinfo;
pathinfo.datasetsDir                = fullfile(workDir, 'UCR-datasets');
pathinfo.saveDirSimulation          = fullfile(workDir, 'results', 'simulation');
pathinfo.saveDirNNshapeDTW          = fullfile(workDir, 'results', 'NNshapeDTW');
pathinfo.saveDirNNDTW               = fullfile(workDir, 'results', 'NNDTW');
pathinfo.saveDirNNsmoothedDTW       = fullfile(workDir, 'results', 'NNsmoothedDTW');

% compile a c file
cfileDir = fullfile(workDir, 'ElasticMeasure', 'DanEllis');
eval(sprintf('cd %s', cfileDir));
mex dpcore.c;
eval(sprintf('cd %s', workDir));

 
if ~exist(pathinfo.datasetsDir, 'dir')
    mkdir(pathinfo.datasetsDir);
end

if ~exist(pathinfo.saveDirSimulation, 'dir')
    mkdir(pathinfo.saveDirSimulation);
end
 
if ~exist(pathinfo.saveDirNNDTW, 'dir')
    mkdir(pathinfo.saveDirNNDTW);
end

if ~exist(pathinfo.saveDirNNshapeDTW, 'dir')
    mkdir(pathinfo.saveDirNNshapeDTW);
end

if ~exist(pathinfo.saveDirNNsmoothedDTW, 'dir')
    mkdir(pathinfo.saveDirNNsmoothedDTW);
end
addpath(genpath(workDir));
