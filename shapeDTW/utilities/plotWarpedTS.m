
function plotWarpedTS(s,t,match, f_shift, h)
% plot warped time series


    narginchk(3,5);
    if numel(s) ~= length(s) || numel(t) ~= length(t)
        error('Only support vector inputs\n');
    end
    
    s = s(:);
    t = t(:);
    
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
    
    %% (1) plot raw signals 
    axes('position', [0.1 0.05 0.8 0.4]);
    s_shift = s + shift;    
    xs = match(:,1);
    xt = match(:,2);    
    ys = s_shift(xs);
    yt = t(xt);    
    lPath = length(match);

    plot(gca, s_shift,'-ro', 'LineWidth',2); hold on; 
    plot(gca, t, '-ks', 'LineWidth', 2); hold on;
    for i=1:lPath
        plot([xs(i) xt(i)], [ys(i) yt(i)], 'b');
        hold on;
    end
%     set(gca,    'xtick',[],'ytick',[] , 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
%     axis tight;
    xlim([1, max(xs(end), xt(end))]);
    
    ymin = min([min(yt) min(s_shift)]);
    ymax = max([max(yt) max(s_shift)]);
    ylim([ymin, ymax]);
    title('matching');
    
    
    %% (2) plot warped signals	 
    axes('position', [0.1 0.55 0.8 0.4]);
    wt = wpath2mat(xt) * t;    
    ws = wpath2mat(xs) * s; %+ shift;    

    plot(gca, ws,'-r', 'LineWidth',2); hold on; 
    plot(gca, wt, '-k', 'LineWidth', 2); hold on;
    
    xlim([1, lPath]);
	ymin = min([min(wt) min(ws)]);
    ymax = max([max(wt) max(ws)]);
    margin = 0.1*(ymax-ymin);
    ylim([ymin-margin, ymax+margin]);
    title('warped time series');

%     set(gca,    'xtick',[],'ytick',[] , 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
%     axis tight;


end