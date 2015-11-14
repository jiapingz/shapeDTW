function handle = wavdemoc(action)

% WAVDEMOC -- a gui style interface for 1D wavelet graphing demo
%
% See also WAVDEMO.

% (C) 1997 Harri Ojanen

if nargin == 0
    biorth = 0;
    action = 'init';
elseif ~ischar(action)
    biorth = action;
    action = 'init';
end


switch action
    case 'init'

        wavdemof
	fixpos
        fig = gcf;

	if biorth
            [families, orders, isbiorth] = wavecoef;
	else
            [families, orders] = wavecoef;
	    isbiorth = zeros(size(orders,1),1);
	end
	U = struct('families', families, 'orders', orders, ...
		'isbiorth', isbiorth);
	if nargout > 0
	    handle = fig;
	    U.mode = 'noclose';
	else
	    U.mode = '';
	end
	set(fig, 'userdata', U);

        famlist = findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        set(famlist, 'string', families);
        setorders(fig, famlist, ordlist);
        draw(fig, famlist, ordlist);
        set(fig, 'handlevisibility', 'callback')

    case 'family'
        fig = gcbf;
        famlist = gcbo; %findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        setorders(fig, famlist, ordlist);
        draw(fig, famlist, ordlist);

    case 'order'
        fig = gcbf;
        famlist = findobj(fig, 'tag', 'family');
        ordlist = gcbo; %findobj(fig, 'tag', 'order');

        draw(fig, famlist, ordlist);

    case 'close'
        fig = gcbf;
	U = get(fig, 'userdata');
	if strcmp(U.mode, 'noclose')
            famlist = findobj(fig, 'tag', 'family');
            ordlist = findobj(fig, 'tag', 'order');
	    fam = get(famlist, 'value');
	    families = U.families;
	    orders = U.orders;
	    %[families, orders] = wavecoef;
	    if any(orders(fam, :))
	        [h,g,h2,g2] = wavecoef(families(fam, :), ...
		    orders(fam,get(ordlist, 'value')));
	    else
	        [h,g,h2,g2] = wavecoef(families(fam, :));
	    end
	    U = struct('h', h, 'g', g, 'h2', h2, 'g2', g2);
	    set(fig, 'userdata', U);
	    uiresume(fig);
	else
	    close(fig);
	end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function setorders(fig, famlist, ordlist)

fam = get(famlist, 'value');
U = get(fig, 'userdata');
families = U.families;
orders = U.orders;
%[families, orders] = wavecoef;

ord = orders(fam, :);
ord = ord(find(ord));
ordstr = num2str(ord(:));
set(ordlist, 'string', ordstr, 'value', 1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function draw(fig, famlist, ordlist)

fam = get(famlist, 'value');
U = get(fig, 'userdata');
families = U.families;
orders = U.orders;
isbiorth = U.isbiorth;
isbio = isbiorth(fam);
%[families, orders] = wavecoef;
if any(orders(fam, :))
    ord = get(ordlist, 'value');
else
    ord = 0;
end

%disp(families(fam,:))
%disp(ord)

if ord
    [h,g,h2,g2] = wavecoef(families(fam, :), orders(fam,ord));
else
    [h,g,h2,g2] = wavecoef(families(fam, :));
end

watchon;

[s,x] = dilation(h, 8, [], 1);
if isbio
    [s2,x] = dilation(h2, 8, [], 1);
end
if length(s)
    w = waveletd(s, x, g);
    if isbio
        w2 = waveletd(s2, x, g2);
    end
else
    y = zeros(2046,1); y(63)=1; w=ifwt1ns(y,h,g);
    y = zeros(2046,1); y(95)=1; s=ifwt1ns(y,h,g);
    if isbio
        y = zeros(2046,1); y(63)=1; w2=ifwt1ns(y,h2,g2);
        y = zeros(2046,1); y(95)=1; s2=ifwt1ns(y,h2,g2);
    end
    x = 0 : length(w)-1;    
end

axes(findobj(fig, 'tag', 'scaling fn axes'))
if isbio
    plot(x,s,x,s2)
else
    plot(x,s)
end
axis tight
set(gca, 'tag', 'scaling fn axes')

axes(findobj(fig, 'tag', 'wavelet axes'))
if isbio
    plot(x,w,x,w2) 
else
    plot(x,w) 
end
axis tight
set(gca, 'tag', 'wavelet axes')

watchoff;
