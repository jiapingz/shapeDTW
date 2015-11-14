function wavoperd(action)

% WPOPERD -- wavelet packet representations of operators
%
% See also WAVOPERD, WMENU.

% (C) 1997 Harri Ojanen


if nargin == 0
    action = 'init';
end


switch action

    case 'init'
        wpoperf
	fixpos
        fig = gcf;

        [families, orders] = wavecoef;

        famlist = findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        set(famlist, 'string', families);
        setorders(fig, famlist, ordlist);

	for i = 1 : size(families, 1)
	    if strcmp(deblank(families(i, :)), 'Haar')
		set(famlist, 'value', i);
	    end
	end

	opers = {...
	    'Conjugate function',...
	    'Hilbert transform',...
	    'Radial function in the kernel',...
	    'Calderon commutator'};
	set(findobj(fig, 'tag', 'operator'), 'string', opers);

	% colorbar
	axes(findobj(gcf, 'tag', 'colorbar'))
	set(gca, 'yaxislocation', 'right', 'xtick', [], 'ytick', [])

        set(fig, 'handlevisibility', 'callback')

    case 'bestbasis'
	set(findobj(gcbf, 'tag', 'bestbasis'), 'value', 1);
	set(findobj(gcbf, 'tag', 'bestlevel'), 'value', 0);

    case 'bestlevel'
	set(findobj(gcbf, 'tag', 'bestbasis'), 'value', 0);
	set(findobj(gcbf, 'tag', 'bestlevel'), 'value', 1);

    case '32'
	set(findobj(gcbf, 'tag', '32'), 'value', 1);
	set(findobj(gcbf, 'tag', '64'), 'value', 0);
	set(findobj(gcbf, 'tag', '128'), 'value', 0);
	
    case '64'
	set(findobj(gcbf, 'tag', '32'), 'value', 0);
	set(findobj(gcbf, 'tag', '64'), 'value', 1);
	set(findobj(gcbf, 'tag', '128'), 'value', 0);
	
    case '128'
	set(findobj(gcbf, 'tag', '32'), 'value', 0);
	set(findobj(gcbf, 'tag', '64'), 'value', 0);
	set(findobj(gcbf, 'tag', '128'), 'value', 1);
	
    case 'family'
        fig = gcbf;
        famlist = gcbo; 
        ordlist = findobj(fig, 'tag', 'order');

        setorders(fig, famlist, ordlist);

    case 'order'
        fig = gcbf;
        famlist = findobj(fig, 'tag', 'family');
        ordlist = gcbo; 

    case 'compute'
	watchon;

	if get(findobj(gcbf, 'tag', '32'), 'value')
	    N = 32;
	elseif get(findobj(gcbf, 'tag', '64'), 'value')
	    N = 64;
	elseif get(findobj(gcbf, 'tag', '128'), 'value')
	    N = 128;
	end
	
	% Wavelet
        famlist = findobj(gcbf, 'tag', 'family');
        ordlist = findobj(gcbf, 'tag', 'order');
	fam = get(famlist, 'value');
	[families, orders] = wavecoef;
	if any(orders(fam, :))
	    [h,g] = wavecoef(families(fam, :), ...
		orders(fam, get(ordlist, 'value')));
	else
	    [h,g] = wavecoef(families(fam, :));
	end

	% Operator
	opernum = get(findobj(gcbf, 'tag', 'operator'), 'value');
	switch opernum
	    case 1
		[W,A] = nsexampl(7, N, h, g, -1);
	    case 2
		[W,A] = nsexampl(1, N, h, g, -1);
	    case 3
		[W,A] = nsexampl(8, N, h, g, -1);
	    case 4
		[W,A] = nsexampl(9, N, h, g, -1);
	end

	axes(findobj(gcbf, 'tag', 'orig'))
	showoper(A, 'trunc', 1e-9, 'noblack')
	set(gca, 'tag', 'orig');
	drawnow

	axes(findobj(gcbf, 'tag', 'trfm'))
	wp = wpa2(A, h, g);
	if get(findobj(gcbf, 'tag', 'bestbasis'), 'value')
	    wp = bestbas2(wp);
	else
	    wp = bestlvl2(wp);
	end
	showwp2(wp, 'trunc', 1e-9, 'noblack')
	set(gca, 'tag', 'trfm')

	% colorbar
	axes(findobj(gcbf, 'tag', 'colorbar'))
	image((2:size(colormap,1))');
	k = wp.wp .* double(wp.sel);
	k = max(abs(k(:)));
	set(gca, 'tag', 'colorbar', 'yaxislocation', 'right', 'xtick', [], ...
		'ytick', [2 size(colormap,1)-1], ...
		'yticklabel', [1e-9; raund(k)],...
		'ydir', 'normal');

	watchoff;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function setorders(fig, famlist, ordlist)

fam = get(famlist, 'value');
[families, orders] = wavecoef;

ord = orders(fam, :);
ord = ord(find(ord));
ordstr = num2str(ord(:));
set(ordlist, 'string', ordstr, 'value', 1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = raund(x)

if x > 0
	d = floor(log(x)/log(10));
	y = round(x/10^(d-1))*10^(d-1);
else 
	y = 0;
end

