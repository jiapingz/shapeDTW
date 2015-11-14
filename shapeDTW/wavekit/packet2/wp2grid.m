function wpgrid2(w)

% WP2GRID -- draws a grid explaining the selected wavelet packet basis
% 
% wp2grid(w)
% 
% Mostly meant to be used by  showwp2.
%
% See also SHOWWP2.

% (C) 1997 Harri Ojanen

if strcmp(get(gca,'color'), 'none')
    bgcolor = get(gcf,'color');
else
    bgcolor = get(gca,'color');
end
if sum(bgcolor) > 1.5
    color = 'k';
else
    color = 'w';
end

l = size(w.wp,3);
hold on
gridaux(w, 0, 2^l, 0, 2^l, 0, color)
hold off



function gridaux(w, xmin, xmax, ymin, ymax, level, color)

sel = 0;
if level > 0
	if any(w.sel(xmin+1:xmax, ymin+1:ymax, level))
%		plot([xmin xmax xmax xmin xmin] + 0.5, ...
%		     [ymin ymin ymax ymax ymin] + 0.5, color);
		plot([ymin ymin ymax ymax ymin] + 0.5, ...
		     [xmin xmax xmax xmin xmin] + 0.5, color);
	        sel = 1;
	end
end
if ~sel
	d = (xmax - xmin) / 2;

	if d >= 1
		gridaux(w, xmin,   xmin+d, ymin,   ymin+d, level+1, color);
		gridaux(w, xmin+d, xmax,   ymin,   ymin+d, level+1, color);
		gridaux(w, xmin,   xmin+d, ymin+d, ymax,   level+1, color);
		gridaux(w, xmin+d, xmax,   ymin+d, ymax,   level+1, color);
	end
end


