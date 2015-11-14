% startup.m -- matlab startup file 
% sets the search path to include all essential wavelet subdirectories

disp('Setting up path for wavelets')
p = pwd;

addpath(p);
addpath(fullfile(p, 'wdemo'));
addpath(fullfile(p, 'packet'));
addpath(fullfile(p, 'packet2'));
addpath(fullfile(p, 'fwt'));

format compact

disp(' ')
disp('To start the interactive wavelet menu: wmenu')
disp(' ')
