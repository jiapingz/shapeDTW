% demo to decompose time series
config;

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%                                 demo 1: decomposition of simulated curves
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

% simulate a random curve with known transitions, and each pure segment of 
% the curve is a complex periodical curve
curve = composeCurves;

% run decomposition algorithm
decomposeCurve(curve);
set(gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);

%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
%                                   demo 2: decomposition of cmu mocap data
%XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
% read cmu mocap data
mocap = readcmu(2);
idx_joints = [9 12 49 60];

% decomposition setting
splitModel = struct('criterion', 'entropy', ...
                    'nclasses',   20, ...
                    'dissimilarity', []);
splitModel = validateSplitModel(splitModel);
decomposeTreeSetting = struct('depth', 10, ...
                              'minlen', 400, ...
                              'splitModel', splitModel); 
% run decomposition                          
for i=1:numel(idx_joints)
    fprintf(1, 'processing joint: %d\n', idx_joints(i));
    joint = mocap(:,idx_joints(i));
    decomposeCurve(joint,[], [], [], decomposeTreeSetting);
    set(gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);
end