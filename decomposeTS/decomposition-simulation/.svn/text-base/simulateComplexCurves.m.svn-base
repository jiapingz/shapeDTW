% simulate simples period curves

saveDir = '/lab/ilab/30/jiaping-iccv/curve-simulations/data/simulations-50-complex';

ncurves = 100;

for i=1:ncurves
    [curve, seglens] = composeCurves;
    simInfo.curve = curve;
    simInfo.seglens = seglens;
    transitions = cumsum(seglens);
    simInfo.transitions = transitions(1:end-1);
    decomposeCurve(curve);
    export_fig(strcat(saveDir, '/', ['curve-' num2str(i) '.png']), '-png', '-m1',  gcf);
    save(strcat(saveDir, '/', ['curve-' num2str(i) '.mat']), 'simInfo');
    close all;
end