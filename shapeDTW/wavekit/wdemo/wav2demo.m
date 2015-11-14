function wav2demo(action)

% WAV2DEMO -- a demo for graphing 2D wavelets
%
% First select either the standard basis (tensor product) or the 
% non-standard basis.
%
% The picture on the left represents how the wavelet coefficient
% matrix is partitioned. Click here to select which wavelet to
% view.
%
% See also WMENU, WAVDEMO, WP2DEMO.

% (C) 1997 Harri Ojanen

if nargin == 0
    action = 'init';
end

switch action
    case 'init'

        wav2demf
	fixpos
        fig = gcf;

        [families, orders] = wavecoef;

        famlist = findobj(fig, 'tag', 'family');
        ordlist = findobj(fig, 'tag', 'order');

        set(famlist, 'string', families);
        setorders(fig, famlist, ordlist);

	set(findobj(fig, 'tag', 'tnsbasis'), 'value', 1);
	set(findobj(fig, 'tag', 'nonstdbasis'), 'value', 0);
        drawbasis(fig, 1);

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

    case 'tnsbasis'
	fig = gcbf;
	set(gcbo, 'value', 1);
	set(findobj(fig, 'tag', 'nonstdbasis'), 'value', 0);
        drawbasis(fig, 1);

    case 'nonstdbasis'
	fig = gcbf;
	set(gcbo, 'value', 1);
	set(findobj(fig, 'tag', 'tnsbasis'), 'value', 0);
        drawbasis(fig, 0);

    case 'buttondown'
	pos = get(gca,'currentpoint');
        pos = round(pos(1,1:2));
	mark(pos)

    case 'compute'
	draw;
    
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

function drawbasis(fig, tns)

axes(findobj(fig, 'tag', 'basis axes'))
delete(get(gca, 'children'))
hold on
%h = fill([0 64 64 0 0]+0.5, [0 0 64 64 0]+0.5, [1 1 1])
axis([0 64 0 64]+0.5)
if nargin == 0
    tns = get(findobj(gcbf, 'tag', 'tnsbasis'), 'value') == 1;
end
if tns
    tnsgrid
else
    nsgrid
end
set(gca, 'xtick', 2.^(0:6), 'ytick', 2.^(0:6));
%axis ij
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

function draw(fig, famlist, ordlist)

if nargin == 0
    fig = gcbf;
    famlist = findobj(fig, 'tag', 'family');
    ordlist = findobj(fig, 'tag', 'order');
    tnsbasis = get(findobj(fig, 'tag', 'tnsbasis'), 'value');
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

tns = get(findobj(fig, 'tag', 'tnsbasis'), 'value');

U = get(fig, 'userdata');
if isfield(U, 'pos')

    watchon;
    pos = U.pos;

    axes(findobj(fig, 'tag', 'wavelet axes'))
    w = zeros(64,64);
    w(pos(1), pos(2)) = 1;
    if tns
        y = ifwt2tns(w, h, g);
    else
        y = ifwt2(w, h, g);
    end		
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
