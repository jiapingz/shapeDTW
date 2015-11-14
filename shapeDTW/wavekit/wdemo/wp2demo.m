function wp2demo(action)

% WP2DEMO -- a demo for graphing 2D wavelet packets 
%
% The picture on the left represents how the wavelet packet coefficient
% matrix is partitioned.
% 
% Select the desired level (1 for finest, 6 for coarsest), then click in
% the left picture to select which wavelet packet to view. Finally press
% 'compute' to view the packet.
%
% See also WMENU, WAV2DEMO, WPDEMO.

% (C) 1997 Harri Ojanen

if nargin == 0
    action = 'init';
end

switch action
    case 'init'

        wp2demof
	fixpos
        fig = gcf;

        [families, orders] = wavecoef;

        famlist = findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        set(famlist, 'string', families);
        setorders(fig, famlist, ordlist);

        setlevel(fig, 1);
        drawbasis(fig, 1);

        %draw(fig, famlist, ordlist);
        set(fig, 'handlevisibility', 'callback')

    case 'compute'
        draw;

    case 'family'
        fig = gcbf;
        famlist = gcbo; %findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        setorders(fig, famlist, ordlist);
        %draw(fig, famlist, ordlist);

    case 'order'
        fig = gcbf;
        famlist = findobj(fig, 'tag', 'family');
        ordlist = gcbo; %findobj(fig, 'tag', 'order');

        %draw(fig, famlist, ordlist);

    case 'level'
	fig = gcbf;
        level = get(gcbo, 'tag');
        level = str2num(level(7));
        setlevel(fig, level);
        drawbasis(fig, level);
	%draw;

    case 'buttondown'
	pos = get(gca,'currentpoint');
        pos = round(pos(1,1:2));
	mark(pos)
        %draw;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function setlevel(fig, level)

for i = 1 : 6
    set(findobj(fig, 'tag', ['level ' num2str(i)]), 'value', i == level);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mark(pos)

x = pos(1);
y = pos(2);

%U = get(gcbf, 'userdata');
%if isfield(U, 'hpos')
%    delete(U.hpos)
%end
delete(findobj(gcbf, 'tag', 'marker'));
hold on
U.pos = pos;
U.hpos = fill([x x+1 x+1 x x]-0.5, [y y y+1 y+1 y]-0.5, [1 0 0]);
setbuttondowns(U.hpos);
set(gcbf, 'userdata', U);
set(U.hpos, 'tag', 'marker');
hold off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function drawbasis(fig, level)

axes(findobj(fig, 'tag', 'basis axes'))
delete(get(gca, 'children'))
hold on
axis([0 64 0 64]+0.5)

hold on;
for i = 0 : 64/2^level : 64
    plot([i i]+.5, [0 64]+.5)
    plot([0 64]+.5, [i i]+.5)
end

setbuttondowns(get(gca, 'children'))	

U = get(fig, 'userdata');
U.hpos = [];
set(fig, 'userdata', U);
if isfield(U, 'pos')
    mark(U.pos);
end
hold off



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function setbuttondowns(h)

for i = 1 : length(h)
    set(h(i), 'buttondownfcn', 'wav2demo buttondown');
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

function l = findlevel(fig)

for i = 1 : 6
    if get(findobj(fig, 'tag', ['level ' num2str(i)]), 'value')
        l = i;
    end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function draw(fig, famlist, ordlist)

if nargin == 0
    fig = gcbf;
    famlist = findobj(fig, 'tag', 'family');
    ordlist = findobj(fig, 'tag', 'order');
end

fam = get(famlist, 'value');
[families, orders] = wavecoef;
if any(orders(fam, :))
    ord = get(ordlist, 'value');
else
    ord = 0;
end

if ord
    [h,g] = wavecoef(families(fam, :), orders(fam,ord));
else
    [h,g] = wavecoef(families(fam, :));
end

level = findlevel(fig);

U = get(fig, 'userdata');
if isfield(U, 'pos')

    watchon;
    pos = U.pos;

    axes(findobj(fig, 'tag', 'wavelet axes'))
    w.wp = zeros(64, 64, 6);
    w.wp(pos(1), pos(2), level) = 1;
    w.sel = uint8(w.wp);
    w.sel(:, :, level) = uint8(ones(64, 64));
    y = wps2(w, h, g);
    surf(1:64, 1:64, y);
    axis tight
    set(gca, 'tag', 'wavelet axes')

    drawnow
    watchoff;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mi, ma] = minmax(MI, MA)

if MI == MA
    mi = MI - 0.5;
    ma = MA + 0.5;
else
    mi = MI;
    ma = MA;
end




