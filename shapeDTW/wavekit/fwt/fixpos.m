function fixpos(fig);

% FIXPOS -- fixes a figure to lie inside the screen
%
% fixpos
% fixpos(fig)

% (C) 1997 Harri Ojanen

if nargin == 0, fig = gcf; end

oldunits = get(0,'units');
set(0,'units','pixels');
screen = get(0,'screensize');
set(0,'units',oldunits);

screenwidth = screen(3);
screenheight = screen(4);

oldunits = get(fig,'units');
set(fig,'units','pixels');
pos = get(fig,'position');

left = pos(1);
bottom = pos(2);
width = pos(3);
height = pos(4);
right = left + width;
top = bottom + height;

change = 0;

if right > screenwidth
    if width > screenwidth
        width = screenwidth;
	left = 1;
    else
        left = left - (right - screenwidth);
    end
    change = 1;
end
	
if top > screenheight
    if height > screenheight
        height = screenheight;
	bottom = 1;
    else
        bottom = bottom - (top - screenheight);
    end
    change = 1;
end
	
if change
    set(fig,'position',[left bottom width height]);
end
set(fig,'units',oldunits);
