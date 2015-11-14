function plotscatter(xacc, yacc, t_xlabel, t_ylabel, t_title)
% Texas Sharpshooter plot to show comparisons between two algorithms
% input: xacc, yacc, accuracies, range from 0 to 1;
%        xlabels_, ylabels_, usually the name of the algorithm
%        tilte, the title of the plot
    narginchk(2,5);
    if nargin == 2
        t_xlabel = '';
        t_ylabel = '';
        t_title = '';
    elseif nargin == 3
        t_ylabel = '';
        t_title = '';
    elseif nargin == 4
        t_title = '';
    end

    figure;     
    plot([0 1], [0 1], 'linewidth', 2, 'color', [0 0 0]); hold on;
    scatter(xacc, yacc, 120 ,'MarkerEdgeColor','r',...
                  'MarkerFaceColor','r'); hold on;

    minVal = min(xacc);
    minVal = min(minVal, min(yacc));
    sVal = 0.1*(floor(minVal*10));

    ytick = sVal:0.1:1;
    yticklabel = {};
    for j=1:numel(ytick)
     yticklabel = cat(1, yticklabel, sprintf('%.1f', ytick(j)));
    end

    set(gca, 'xtick', ytick, 'yticklabel', yticklabel);
    set(gca, 'ytick', ytick, 'yticklabel', yticklabel);

%     p = signrank(xacc, yacc);

    ylabel(t_ylabel, 'fontsize', 40);
    xlabel(t_xlabel, 'fontsize', 40);
    title(t_title, 'fontsize', 20);
    axis equal;

    set(gca, 'xlim', [sVal 1]);
    set(gca, 'ylim', [sVal 1]);
    set(gca,'linewidth',2);
    set(gca, 'fontsize', 35);
    set(gcf, 'position', [400 400 900 900]);


end