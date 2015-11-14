function fwtmex(optionsfile)

% MAKEMEX -- compile fast wavelet transform mex files 
%
% Usage:
%     makemex

% (C) 1998 Harri Ojanen

% Check working directory:

if exist('fwt1step.c') ~=  2
	error('You must be in the wavekit/fwt directory.')
end

% but exist finds the file along the path, mex requires it to
% be in the working directory. So the above test may be ok, but
% we still are not where we should be. Check the output of pwd,
% but don't make this fatal, in case the name of the directory 
% is different from fwt.
p = pwd;
if length(p) < 3
	disp('ERROR: you must be in the wavekit/fwt directory')
elseif ~strcmp(upper(p(length(p)-2:length(p))), 'FWT')
	disp('ERROR: you must be in the wavekit/fwt directory')
end

if nargin == 0
	disp('Compiling fwt1step.c')
	!mex fwt1step.c
	disp('Compiling fwt2step.c')
	!mex fwt2step.c
	disp('Compiling ifwt1stp.c')
	!mex ifwt1stp.c
	disp('Compiling ifwt2stp.c')
	!mex ifwt2stp.c
	disp('done')
else
	disp('Compiling fwt1step.c')
	eval(['!mex -f ' optionsfile ' fwt1step.c'])
	disp('Compiling fwt2step.c')
	eval(['!mex -f ' optionsfile ' fwt2step.c'])
	disp('Compiling ifwt1stp.c')
	eval(['!mex -f ' optionsfile ' ifwt1stp.c'])
	disp('Compiling ifwt2stp.c')
	eval(['!mex -f ' optionsfile ' ifwt2stp.c'])
	disp('done')
end

cd(p)
