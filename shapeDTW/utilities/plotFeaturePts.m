function plotFeaturePts(TS, subsequencesIdx)
    figure; 
    plot(TS, 'color', 'b', 'linewidth', 2); hold on;
    
    f_subsequencesIdx = subsequencesIdx;    
    f_mag = TS(f_subsequencesIdx); 
    
    % plot feature points
	scatter(f_subsequencesIdx, f_mag, 100, 'o', 'markeredgecolor', 'r', 'linewidth', 4); hold on;    
    
	xlim([1, length(TS)]);
    ylim([min(TS) max(TS)]);
    set(gca, 'xtick',[], 'xticklabel', [], 'ytick',[] , 'yticklabel', [], 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
%     set(h,  'xtick',[], 'xticklabel', [], 'XColor', [1 1 1])  ;
    
    set(gcf, 'position', [500 500 1400 300]);
    
end
