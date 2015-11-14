function plotHybridPts(TS, subsequencesIdx, markers)
    figure; 
    plot(TS, 'color', 'b', 'linewidth', 2); hold on;
    
    f_subsequencesIdx = subsequencesIdx(markers == 0);
    p_subsequencesIdx = subsequencesIdx(markers == 1);
    v_subsequencesIdx = subsequencesIdx(markers == -1);
    
    f_mag = TS(f_subsequencesIdx);
    p_mag = TS(p_subsequencesIdx);
    v_mag = TS(v_subsequencesIdx);
    
    % plot flat points
% 	scatter(f_subsequencesIdx, f_mag, 50, 'o', 'markeredgecolor', 'k'); hold on;
    scatter(f_subsequencesIdx, f_mag, 100, 'o', 'markeredgecolor', 'k', 'linewidth', 4); hold on;    

    
    % plot peak points
%     scatter(p_subsequencesIdx, p_mag, 50, 'o', 'markeredgecolor', 'g'); hold on;
    scatter(p_subsequencesIdx, p_mag, 100, 'o', 'markeredgecolor', 'r', 'linewidth', 4); hold on;    

    
    % plot valley points
%     scatter(v_subsequencesIdx, v_mag, 50, 'o', 'markeredgecolor', 'r');  
	scatter(v_subsequencesIdx, v_mag, 100, 'o', 'markeredgecolor', 'r', 'linewidth', 4);  

    
    
	xlim([1, length(TS)]);
    ylim([min(TS) max(TS)]);
    set(gca, 'xtick',[], 'xticklabel', [], 'ytick',[] , 'yticklabel', [], 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
%     set(h,  'xtick',[], 'xticklabel', [], 'XColor', [1 1 1])  ;
    
    set(gcf, 'position', [500 500 1400 300]);
    
end


