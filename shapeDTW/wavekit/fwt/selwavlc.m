function handle = selwavlc(action)

% SELWAVLC -- callback routine for selwavlt
%
% See also SELWAVLT.

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

        selwavlf
	fixpos
        fig = gcf;

	if biorth
            [families, orders, isbiorth] = wavecoef;
	else
            [families, orders] = wavecoef;
	end
	U = struct('families', families, 'orders', orders);
	set(fig, 'userdata', U);

        famlist = findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        set(famlist, 'string', families);
        setorders(fig, famlist, ordlist);
	handle = fig;
        set(fig, 'handlevisibility', 'callback')

    case 'family'
        fig = gcbf;
        famlist = gcbo; %findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        setorders(fig, famlist, ordlist);

    case 'order'
        fig = gcbf;
        famlist = findobj(fig, 'tag', 'family');
        ordlist = gcbo; %findobj(fig, 'tag', 'order');

    case 'ok'
        fig = gcbf;
        famlist = findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');
	fam = get(famlist, 'value');
	U = get(fig, 'userdata');
	families = U.families;
	orders = U.orders;
	%[families, orders] = wavecoef;
	if any(orders(fam, :))
	    [h,g,h2,g2] = wavecoef(families(fam, :), ...
	        orders(fam,get(ordlist, 'value')));
	else
	    [h,g,h2,g2] = wavecoef(families(fam, :));
	end
	U.h = h; U.g = g; U.h2 = h2; U.g2 = g2;
	set(fig, 'userdata', U);
	uiresume(fig);

    case 'cancel'
	U.h = []; U.g = []; U.h2 = []; U.g2 = [];
	set(gcbf, 'userdata', U);
	uiresume(gcbf);
	
end



function setorders(fig, famlist, ordlist)

fam = get(famlist, 'value');
U = get(fig, 'userdata');
orders = U.orders;
%[families, orders] = wavecoef;

ord = orders(fam, :);
ord = ord(find(ord));
ordstr = num2str(ord(:));
set(ordlist, 'string', ordstr, 'value', 1);

