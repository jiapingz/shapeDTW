function wavdemoc(action)

% WPDEMO -- graphs of wavelet packets
%
% Packets with lowest frequency:
%     Eight wavelet packets with lowest frequency are graphed. The '0'
%     packet is the corresponding wavelet and the '1' packet is the
%     scaling function. These are non-periodic functions.
%
% Random selection:
%     These are randomly selected periodic wavelet packets.
%     The titles identify the packet:
%         s   is the scale (1 for finest, 8 for coarsest scale)
%         f   frequency
%         p   position of the packet
%
% See also WMENU, WAVDEMO.

% (C) 1997 Harri Ojanen

if nargin == 0
    action = 'init';
end

switch action
    case 'init'

        wpdemof
	fixpos
        fig = gcf;

        [families, orders] = wavecoef;

        famlist = findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        set(famlist, 'string', families);
        setorders(fig, famlist, ordlist);
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

    case 'low'
	set(findobj(gcbf, 'tag', 'low'), 'value', 1);
	set(findobj(gcbf, 'tag', 'random'), 'value', 0);
        famlist = findobj(gcbf, 'tag', 'family');
        ordlist = findobj(gcbf, 'tag', 'order');

    case 'random'
	set(findobj(gcbf, 'tag', 'low'), 'value', 0);
	set(findobj(gcbf, 'tag', 'random'), 'value', 1);
        famlist = findobj(gcbf, 'tag', 'family');
        ordlist = findobj(gcbf, 'tag', 'order');

    case 'compute'
        famlist = findobj(gcbf, 'tag', 'family');
        ordlist = findobj(gcbf, 'tag', 'order');
	draw(gcbf, famlist, ordlist);

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

function draw(fig, famlist, ordlist)

fam = get(famlist, 'value');
[families, orders] = wavecoef;
if any(orders(fam, :))
    ord = get(ordlist, 'value');
else
    ord = 0;
end

random = get(findobj(gcbf, 'tag', 'random'), 'value');

if ord
    [h,g] = wavecoef(families(fam, :), orders(fam,ord));
else
    [h,g] = wavecoef(families(fam, :));
end

watchon;

if random
    n = 8;
    miny = [];
    maxy = [];
    for i = 1 : 8
        axes(findobj(fig, 'tag', ['Axes' num2str(i)]));
	cla; hold on
	w = zeros(n*2^n,1);
	j = floor(rand*length(w))+1;
	w(j) = 1;
	w = struct('wp', w, 'sel', uint8(w));
	y = wps1(w,h,g);
	miny = [miny min(y)];
	maxy = [maxy max(y)];
	plot(y);
	[s,f,p] = idxtosfp(j, 2^n);
	title(sprintf('s=%d, f=%d, p=%d', s, f, p));
	axis tight;
	hold off;
    end
    miny = min(miny); miny = miny + .1 * sign(miny);
    maxy = max(maxy); maxy = maxy + .1 * sign(maxy);
    for i = 1 : 8
        axes(findobj(fig, 'tag', ['Axes' num2str(i)]));
	axis([1 length(y) miny maxy])
    end

else
    [W, xx] = wpplots(h, g, 8, 8);
    if ~isempty(W)
        miny = min(W(:)); miny = miny + .1 * sign(miny);
        maxy = max(W(:)); maxy = maxy + .1 * sign(maxy);
        for i = 1 : 8
    	    j = igc(i-1)+1;
            axes(findobj(fig, 'tag', ['Axes' num2str(j)]));
            plot(xx, W(:,i));
	    title(sprintf('%d', j-1));
            axis([min(xx) max(xx) miny maxy])
            set(gca, 'tag',  ['Axes' num2str(j)]);
        end
    else
        for i = 1 : 8
            axes(findobj(fig, 'tag', ['Axes' num2str(i)]));
            cla
        end
    end    
end

watchoff;
