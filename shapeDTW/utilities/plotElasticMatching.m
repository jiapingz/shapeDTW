% visualize the match between two signals matched by dynamic time warping

function plotElasticMatching(s,t,match, f_shift, h)

    narginchk(3,5);
    if numel(s) ~= length(s) || numel(t) ~= length(t)
        error('Only support vector inputs\n');
    end
    
    if size(match,2) ~= 2
        match = match';
    end
    
    if ~exist('f_shift','var') || isempty(f_shift)
        f_shift = true;
    end
    
    if ~exist('h', 'var') || isempty(h)
         h = figure;
    end
    
    switch f_shift
        case true
            mins = min(s);
            maxs = max(s);
            mint = min(t);
            maxt = max(t);

            shift = max([maxt-mint maxs-mins]);
        otherwise
            shift = 0;
    end
    
    s = s + shift;
    
    xs = match(:,1);
    xt = match(:,2);
    
    ys = s(xs);
    yt = t(xt);
    
    lPath = length(match);
    
 
%     set(h, 'OuterPosition', [400 500 1200 600]);
%     axes(h);
    plot(gca, s,'-ro', 'LineWidth',2); hold on; 
    plot(gca, t, '-ks', 'LineWidth', 2); hold on;
    for i=1:lPath
        plot([xs(i) xt(i)], [ys(i) yt(i)], 'b');
        hold on;
    end
%     strTitle = sprintf('Dynamic Time Warping: y-shift-%.1f', shift);
%     title('Dynamic Time Warping', 'FontSize', 30);
    set(gca,    'xtick',[],'ytick',[] , 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
    axis tight;
%     set(gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);


end