function wpdemo(action,f)

% WPSIG -- wavelet packet demo (signal analysis)
%
% Select one of the seven signals to view it in wavelet packet bases.
%
% Import... can be used to study a vector from the matlab workspace.
%
% See also WMENU, SHOWWP.

% (C) 1997 Harri Ojanen


if nargin == 0
    action = 'init';
else
    x = 0 : 63;
end


switch action

    case 'init'
	wpsigf;
	fixpos
        fig = gcf;

        [families, orders] = wavecoef;

        famlist = findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        set(famlist, 'string', families);

	for i = 1 : size(families, 1)
	    if strcmp(deblank(families(i, :)), 'Coiflet')
		set(famlist, 'value', i);
	        setorders(fig, famlist, ordlist);
		set(ordlist, 'value', find(orders(i, :) == 24));
	    end
	end

        set(fig, 'handlevisibility', 'callback')

    case 'family'
        fig = gcbf;
        famlist = gcbo;
        ordlist = findobj(fig, 'tag', 'order');
        setorders(fig, famlist, ordlist);

    case 'fastsin'
        f = sin(2*x);
	show(f);

    case 'slowsin'
        f = sin(x/2);
	show(f);

    case 'inv'
        f = 1./(x-9.5);
	show(f);

    case 'spike'
        f = zeros(size(x));
        f(9:17) = [2 4 6 8 10 8 6 4 2];
	show(f);

    case 'noise'
        f = randn(size(x));
	show(f);

    case 'fastsinnoise'	
        f = sin(2*x) + randn(size(x))/2;
	show(f);

    case 'chirp'
        f=sin(2*pi*x/63 .* x/5);
	show(f);

    case 'import'
	f = f(:);
        if abs(log2(length(f)) - round(log2(length(f)))) > 1e-12
	    msgbox('The variable must be a vector whose length is a power of 2.');
        else    
	    show(f);
	end
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

function show(f)

fig = gcbf;
famlist = findobj(fig, 'tag', 'family');
ordlist = findobj(fig, 'tag', 'order');
fam = get(famlist, 'value');
[families, orders] = wavecoef;
if any(orders(fam, :))
    [h,g] = wavecoef(families(fam, :), orders(fam, get(ordlist, 'value')));
else
    [h,g] = wavecoef(families(fam, :));
end

wp = wpa1(f,h,g); 
showwp(wp,f,h,g)
