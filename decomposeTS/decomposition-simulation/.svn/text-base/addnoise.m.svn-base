
% this script is used to add noise to the original curve 
% (1) iid noise
% (2) 10% * magnitude


simulatedcurvesDir = '/lab/ilab/30/jiaping-iccv/curve-simulations/data/simulations-50-complex';
noisecurvesDir     = '/lab/ilab/30/jiaping-iccv/curve-simulations/data/simulations-50-complex-noise-a';
if ~exist(noisecurvesDir, 'dir')
    mkdir(noisecurvesDir);
end

curveFiles = dir(strcat(simulatedcurvesDir, '/*.mat'));
nCurves = numel(curveFiles);

minLen = Inf;
maxLen = 0;

for i=1:nCurves
    i
    curveInfo = loadMatFile(simulatedcurvesDir, curveFiles(i).name);
    curve = curveInfo.simInfo.curve;
    seglens = curveInfo.simInfo.seglens;
    transitions = curveInfo.simInfo.transitions;
    
    eidx = cumsum(seglens);
    sidx = eidx - seglens + 1;
    
    nsegs = numel(seglens);
    
    noise_curve = [];
    for j=1:nsegs
        j_seg = curve(sidx(j):eidx(j));
        j_mag = max(j_seg) - min(j_seg);
        j_mag_noise = 0.03*j_mag;
        j_noises = j_mag_noise * randn(1, seglens(j));
        j_noise_curve = j_seg + j_noises;
%         figure; 
%         plot(j_seg, 'r'); hold on;
%         plot(j_noise_curve + 1.5*j_mag, 'b')
%         close all;

        noise_curve = cat(2, noise_curve, j_noise_curve);
        
    end
    
    simInfo.curve = noise_curve;
    simInfo.seglens = seglens;
    simInfo.transitions = transitions;
    
    save(strcat(noisecurvesDir, '/', curveFiles(i).name), 'simInfo');

end
