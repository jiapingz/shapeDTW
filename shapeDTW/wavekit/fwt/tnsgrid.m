function tnsgrid(l,replace)

% TNSGRID -- Draws a grid explaining the partition of a tensor product matrix.
%
% tnsgrid(minlevel)
%
% minlevel    All small levels with level number less than or equal to
% this parameter are NOT drawn. This parameter is optional. The default
% is to draw all levels, which may produce too much clutter with large
% matrices.
%
% Use as an overlay for images produced by showoper.
%
% See also SHOWOPER, NSGRID.

% (C) 1993-1997 Harri Ojanen

if nargin == 0, l = 0; end
if nargin <= 1, replace = 0; end

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

if strcmp(version, '4.0')
    d = 1;
else
    d = 0.5;
end
	
if ~replace
    hold on
end
a = axis;

for i=l:round(log(a(2)-d)/log(2))-1,
    plot([2^i+d 2^i+d], [d     a(4)],  color);
    plot([d     a(2)],  [2^i+d 2^i+d], color);
end

plot([a(1) a(2) a(2) a(1) a(1)], [a(3) a(3) a(4) a(4) a(3)], color)
hold off

