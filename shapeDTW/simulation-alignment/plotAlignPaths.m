
function plotAlignPaths(align, legendStrs)
% plot alignment paths (multiple)
% inputs:   
%         align -- alignment paths, in cell format
    narginchk(1,2);
    if isempty(align)
        return;
    end
    nAlignments = numel(align);
    if nAlignments == 0
        return;
    end
    
    %% make sure each alignment is consistent with others
    p = align{1}(:,1);
    q = align{1}(:,2);
    
    [p, idx] = sort(p);
    q = q(idx);
    
    len_p = p(end);
    len_q = q(end);
    
    align{1} = [p q];
    
    for i=2:nAlignments
        p = align{i}(:,1);
        q = align{i}(:,2);
       
        [p, idx] = sort(p);
        q = q(idx);
        
        if p(end) ~= len_p
            tmp = p;
            p = q;
            q = tmp;
            align{i} = [p q];
        end        
    end
    
    
    figure;    
    for i=1:nAlignments        
        p = align{i}(:,1);
        q = align{i}(:,2);
        
        if i == 1
            plot(p,q, 'linewidth', 3, 'color', 'k');
        elseif i == 2
            plot(p,q, 'linewidth', 3, 'color', 'b');
        elseif i == 3
            plot(p,q, 'linewidth', 3, 'color', 'm');
        else
            plot(p,q, 'linewidth', 3, 'color', [rand rand rand]);

        end
        
%         plot(p,q, 'linewidth', 3, 'color', [rand rand rand]);
 %        loglog(p,q, 'linewidth', 3, 'color', [rand rand rand]);
        hold on;
    end
%     set(gca, 'xtick', 1:round(len_p/10):len_p, 'ytick', ...
%                     1:round(len_q/10):len_q);
    axis equal;
    set(gca, 'fontsize', 20);
    xlim([1 len_p]);
	ylim([1 len_q]);

    
    if exist('legendStrs', 'var')
        legend(legendStrs, 'fontsize', 25);
    end
    

end