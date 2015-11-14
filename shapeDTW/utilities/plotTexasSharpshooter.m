
function plotTexasSharpshooter(expGain, actGain)
% 
%     expGain = accTrainOurs./accTrainNNDTW;
%     actGain = accTestOurs./accTestNNDTW;
    narginchk(2,2);
    
    minExp = floor(min(expGain)*10)*0.1;
    maxExp = floor(max(expGain)) + ceil(10*(max(expGain) - floor(max(expGain))))*0.1;

    minAct = floor(min(actGain)*10)*0.1;
    maxAct = floor(max(actGain)) + ceil(10*(max(actGain) - floor(max(actGain))))*0.1;



    xticklabels = {};
    yticklabels = {};
    xranges = minExp:.1:maxExp;
    yranges = minAct:.1:maxAct;

    for i=1:length(xranges)
        tmp = sprintf('%.1f', xranges(i));
        xticklabels = cat(1, xticklabels, tmp);
    end


    for i=1:length(yranges)
        tmp = sprintf('%.1f', yranges(i));
        yticklabels = cat(1, yticklabels, tmp);
    end



    figure;
    if minExp < 1 && minAct < 1
        rectangle('Position', [minExp minAct 1-minExp 1-minAct], 'edgecolor', 'k', 'facecolor', [1 1 0.5], 'linewidth', 2);  hold on;      
    end
    if maxExp > 1 && maxAct > 1
        rectangle('Position', [1 1 maxExp-1 maxAct-1], 'edgecolor', 'k', 'facecolor', [1 1 0.5], 'linewidth', 2);  hold on;
    end

    scatter(expGain, actGain, 160, 'o', ...
                'markeredgecolor', 'r', 'markerfacecolor', 'r' );  hold on;

    set(gca, 'xtick', xranges, 'xticklabel', xticklabels, ...
             'ytick', yranges, 'yticklabel', yticklabels, ...
             'linewidth', 2, 'box', 'on', 'fontsize', 45);

    xlim([minExp maxExp]);
    ylim([minAct maxAct]);
    xlabel('Expected Accuracy Gain (train)', 'fontsize', 45);
    ylabel('Actual Accuracy Gain (test)', 'fontsize', 45);
%     axis equal;
%     axis tight;
 

end