function [minmax, scaled, cmap] = showoper(oper, O1, O2, O3, ...
    O4, O5, O6, O7, O8, O9, O10, O11, O12)

% showoper -- displays the matrix of an operator graphically
%
% [minmax, scaled, map] = showoper(oper, options...)
%
% oper             the matrix of the operator to display
%
% Options:
%    'trunc'       next option specifies the truncation level (i.e., entries
%                      smaller than this are considered zero; default 0)
%    'ceil'        next option is the ceiling to use (entries larger than
%                      this are all drawn with the same color; default +inf)
%
%    'color'       use colors (default)
%    'gray'        use only grayscale
%
%    'black'       draw entries below truncation in black (default)
%    'noblack'     use the same color as for the smallest nonzero entries
%
%    'colorbar'    display a colorbar (in a separate window)
%    'nocolorbar'  don't (default)
%
%    'colors'      next argument is the number of colors to use (default 64)
%
%    'linear'      use linear scaling
%    'log'         use logarithmic scaling (default)
%
%    'abs'         draw based on the absolute values of the entries (default)
%    'sign'        based on the signs (+, - or 0) of the entries
%                      (using this implies 'color' and 'black')
%    'both'        show both the magnitudes and the signs of the entries
%                      (using this implies 'color' and 'black')
%
%    'menu'        include an option menu in the figure
%
%
% Output arguments:
%
% minmax     Depending on the drawing mode:
%    'abs'         the largest and smallest abs. values of entries in oper
%                      larger than the truncation level
%    'both'        contains separately the largest and smallest positive
%                      and negative values
%    'sign'        empty
%
% scaled           the scaled version of oper, i.e., good for image
% map              the colormap used
%
% (When oper is a scalar, it is interpreted as the figure handle for
% the window where to make changes. This is for internal use.)
%
% See also NSGRID, SHOWMSA, SHOWNSMS.

% (C) 1997 Harri Ojanen

error(nargchk(1,13,nargin));


% Did we get an operator to draw or is this callback?
%
if length(oper) == 1
    %
    % this is callback, find previous values of oper and all options
    %
    hfig = oper;   % figure handle
    %eval(sprintf('global SHOWOPEROPER%d SHOWOPEROPTIONS%d', hfig, hfig));
    %oper = eval(sprintf('SHOWOPEROPER%d', hfig));
    %optn = eval(sprintf('SHOWOPEROPTIONS%d', hfig));
    U = get(hfig, 'userdata');
    oper = U.oper;
    optn = U.optn;

    color = optn(1);
    useblack = optn(2);
    colors = optn(3);
    mode = setstr(optn(4));
    truncation = optn(5);
    ceiling = optn(6);
    scaling = setstr(optn(7));
    colorbar = 0;
else
    %
    % no, here are the default values:
    %
    hfig = [];
    color = 1;
    useblack = 1;
    colorbar = 0;
    colors = 64;
    mode = 'a';
    truncation = 0;
    ceiling = inf;
    scaling = 'g';
end

menu = 0;
command = 0;


% Process options
%
i = 1;
while i <= nargin-1
    opt = eval(sprintf('O%d',i));
    if strcmp(opt, 'color')
	color = 1;
	i = i+1;
    elseif strcmp(opt, 'gray')
	color = 0;
	i = i+1;
    elseif strcmp(opt, 'black')
	useblack = 1;
	i = i+1;
    elseif strcmp(opt, 'noblack')
	useblack = 0;
	i = i+1;
    elseif strcmp(opt, 'colorbar')
	colorbar = 1;
	i = i+1;
    elseif strcmp(opt, 'nocolorbar')
	colorbar = 0;
	i = i+1;
    elseif strcmp(opt, 'colors')
	if i == nargin
	    error('No argument specified for option ''colors''.');
	end
	i = i+1;
	colors = eval(sprintf('O%d', i));
	i = i+1;
    elseif strcmp(opt, 'linear')
	scaling = 'l';
	i = i+1;
    elseif strcmp(opt, 'log')
	scaling = 'g';
	i = i+1;
    elseif strcmp(opt, 'abs')
	mode = 'a';
	i = i+1;
    elseif strcmp(opt, 'sign')
	mode = 's';
	i = i+1;
    elseif strcmp(opt, 'both')
	mode = 'b';
	useblack = 1;
	color = 1;
	i = i+1;
    elseif strcmp(opt, 'menu')
	menu = 1;
	i = i+1;
    elseif strcmp(opt, 'trunc')
	if i == nargin
	    error('No argument specified for option ''trunc''.');
	end
	i = i+1;
	truncation = eval(sprintf('O%d', i));
	i = i+1;
    elseif strcmp(opt, 'ceil')
	if i == nargin
	    error('No argument specified for option ''ceil''.');
	end
	i = i+1;
	ceiling = eval(sprintf('O%d', i));
	i = i+1;
    elseif strcmp(opt, 'trmul10')
        truncation = truncation * 10;
	i = i+1;
    elseif strcmp(opt, 'trdiv10')
        truncation = truncation / 10;
	i = i+1;
    elseif strcmp(opt, 'clmul10')
        ceiling = ceiling * 10;
	i = i+1;
    elseif strcmp(opt, 'cldiv10')
        ceiling = ceiling / 10;
	i = i+1;
    elseif strcmp(opt, 'command')
        command = 1;
	i = i+1;
    else
	error(sprintf('unknow option ''%s''.', opt));
    end
end


% Determine the color of the background
%
if strcmp(get(gca,'color'), 'none')
    bgcolor = get(gcf,'color');
else
    bgcolor = get(gca,'color');
end


% The number of nonblack colors to use
%
N = colors - useblack;


% Truncating the entries
%
op = oper;
if truncation > 0
    i = find(abs(oper) < truncation);
    op(i) = zeros(size(i));
end
if ceiling ~= inf
    i = find(abs(oper) > ceiling);
    op(i) = ceiling * ones(size(i)) .* sign(oper(i));
end
nonzeros = find(op ~= 0);


% For future reference
if mode == 'b'
    pos = find(op > 0);
    neg = find(op < 0);
end


% Log scale
%
if scaling == 'g'
    if mode == 'a' | mode == 'b'
        op(nonzeros) = log10(abs(op(nonzeros)));
    end
end


% Scaling
%
if mode == 'a'
    ma = max(max(op(nonzeros)));
    mi = min(min(op(nonzeros)));
    op(nonzeros) = round((op(nonzeros) - mi) / (ma-mi) * (N - 1)) ...
	+ useblack; 
    op = op + 1;
elseif mode == 'b'
    ma = max(max(op(pos)));
    mi = min(min(op(pos)));
    op(pos) = round((op(pos) - mi) / (ma-mi) * (floor(N/2) - 1)) + 1;
    ma = max(max(op(neg)));
    mi = min(min(op(neg)));
    op(neg) = round((op(neg) - mi) / (ma-mi) * (floor(N/2) - 1)) ...
	 + floor(N/2) + 1;
    op = op + 1;
else
    op = sign(op) + 2;
end


% Choose the colormap
%
if color
    if mode == 's'
	map = [0 0 1; 0 0 0; 1 0 0];
    elseif mode == 'a'
        if useblack
            map = jet(colors-1);
            map = [bgcolor; map];
        else
            map = jet(colors);
        end
    else
	j = jet(ceil(colors/.6));
        l = size(j,1);
        b1 = round(l*.075);
        b2 = b1 + floor(N/2) - 1;
        r1 = round(l*.625);
        r2 = r1 + floor(N/2) - 1;
	map = [bgcolor; 
               j(r1:r2, :);
               j(b2:-1:b1, :)];
    end
else
    if mode == 's'
        map = [0.5 0.5 0.5; 0 0 0; 1 1 1];
    elseif mode == 'a'
        if sum(bgcolor) > 1.5
            map = 1-gray(colors);
        else
            map = gray(colors);
        end
    end
end


% Draw the image
%
if length(hfig)
    figure(hfig)
end
image(op)
axis square
axis off
colormap(map)


% Draw the colorbar
%
if colorbar
    thisone = gcf;
    figure;
    if mode == 'a'
        image(1:colors);
        colormap(map);
    elseif mode == 's'
        image([1 2 3]);
        colormap(map);
    else
        image([floor(N/2)+2: N, 1, 2:floor(N/2)+1]);
        colormap(map);
    end
    figure(thisone);
end


% Output arguments
%
if nargout >= 1
    if mode == 'a'
        minmax = [min(min(abs(oper(nonzeros)))) max(max(abs(oper(nonzeros))))];
    elseif mode == 'b'
        minmax = [min(min(oper(neg))) max(max(oper(neg))) ...
                  min(min(oper(pos))) max(max(oper(pos)))];
    else
        minmax = [];
    end
end
if nargout >= 2
    scaled = op;
end
if nargout >= 3
    cmap = map;
end


% Global variables for saving oper and different options
%
%eval(sprintf('global SHOWOPEROPER%d SHOWOPEROPTIONS%d', gcf, gcf));
%if menu | length(eval(sprintf('SHOWOPEROPTIONS%d', gcf)))
%    eval(sprintf('SHOWOPEROPER%d = oper;', gcf));
%    eval([sprintf('SHOWOPEROPTIONS%d', gcf), '= [color, useblack, colors,', ...
%        'abs(mode),truncation, ceiling, abs(scaling)];']);
%end

U.oper = oper;
U.optn = [color, useblack, colors, abs(mode), ...
		truncation, ceiling, abs(scaling)];
set(gcf, 'userdata', U);

% Option menu
%
if menu & ~length(findobj(gcf,'label','ShowOperOptions'))
    h = uimenu(gcf, 'label', 'ShowOperOptions');
    uimenu(h, 'label','no truncation', 'callback', ...
        'showoper(gcf,''trunc'',0);');
    uimenu(h, 'label','truncation = 1e-9', 'callback', ...
        'showoper(gcf,''trunc'',1e-9);');
    uimenu(h, 'label','truncation * 10', 'callback', ...
        'showoper(gcf,''trmul10'');');
    uimenu(h, 'label','truncation / 10', 'callback', ...
        'showoper(gcf,''trdiv10'');');
    uimenu(h, 'label','no ceiling', 'callback', ...
        'showoper(gcf,''ceil'',inf);');
    uimenu(h, 'label','ceiling = 1e5', 'callback', ...
        'showoper(gcf,''ceil'',1e5);');
    uimenu(h, 'label','ceiling * 10', 'callback', ...
        'showoper(gcf,''clmul10'');');
    uimenu(h, 'label','ceiling / 10', 'callback', ...
        'showoper(gcf,''cldiv10'');');
%    uimenu(h, 'separator', 'on');
    uimenu(h, 'label','color', 'callback', ...
        'showoper(gcf,''color'');','separator','on');
    uimenu(h, 'label','gray', 'callback', ...
        'showoper(gcf,''gray'');');
    uimenu(h, 'label','use black', 'callback', ...
        'showoper(gcf,''black'');');
    uimenu(h, 'label','no black', 'callback', ...
        'showoper(gcf,''noblack'');');
    uimenu(h, 'label','256 colors', 'callback', ...
        'showoper(gcf,''colors'',256);');
    uimenu(h, 'label','64 colors', 'callback', ...
        'showoper(gcf,''colors'',64);');
    uimenu(h, 'label','colorbar', 'callback', ...
        'showoper(gcf,''colorbar'');');
%    uimenu(h, 'separator', 'on');
    uimenu(h, 'label','linear', 'callback', ...
        'showoper(gcf,''linear'');','separator','on');
    uimenu(h, 'label','log', 'callback', ...
        'showoper(gcf,''log'');');
    uimenu(h, 'label','abs', 'callback', ...
        'showoper(gcf,''abs'');');
    uimenu(h, 'label','sign', 'callback', ...
        'showoper(gcf,''sign'');');
    uimenu(h, 'label','both', 'callback', ...
        'showoper(gcf,''both'');');
%    uimenu(h, 'separator', 'on');
    uimenu(h, 'label','command', 'callback', ...
        'showoper(gcf,''command'');','separator','on');
end


% Display the command that would produce the result seen in the figure
%
if command
    fprintf('showoper(  ');
    if ~color
        fprintf(',''gray''');
    end
    if truncation > 0
        fprintf(',''trunc'',%g', truncation);
    end
    if ceiling < inf
        fprintf(',''ceil'',%g', ceiling);
    end
    if ~useblack
        fprintf(',''noblack''');
    end
    if colors ~= 64
        fprintf(',''colors'',%d', colors);
    end
    if scaling == 'l'
        fprintf(',''linear''');
    end
    if mode == 's'
        fprintf(',''sign''');
    elseif mode == 'b'
        fprintf(',''both''');
    end
    fprintf(');\n');
end
    
