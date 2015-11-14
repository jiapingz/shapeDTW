function wavmultd(action)

% WAVMULTD -- demo of fast multiplication in wavelet bases

% (C) 1997 Harri Ojanen

if nargin == 0
    action = 'init';
end


switch action

    case 'init'
        wavmultf
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

	set(findobj(fig, 'tag', 'level'), 'string', ...
             {'0', '1e-1', '1e-2', '1e-3', '1e-4', '1e-5', '1e-6', ...
              '1e-7', '1e-8', '1e-9', '1e-10', '1e-11', '1e-12', '1e-13', ...
              '1e-14', '1e-15', '1e-16'}');

	% colorbar
	axes(findobj(gcf, 'tag', 'colorbar'))
	set(gca, 'yaxislocation', 'right', 'xtick', [], 'ytick', [])

        set(fig, 'handlevisibility', 'callback')

    case '64'
	set(findobj(gcbf, 'tag', '64'), 'value', 1);
	set(findobj(gcbf, 'tag', '128'), 'value', 0);
	set(findobj(gcbf, 'tag', '256'), 'value', 0);
	
    case '128'
	set(findobj(gcbf, 'tag', '64'), 'value', 0);
	set(findobj(gcbf, 'tag', '128'), 'value', 1);
	set(findobj(gcbf, 'tag', '256'), 'value', 0);
	
    case '256'
	set(findobj(gcbf, 'tag', '64'), 'value', 0);
	set(findobj(gcbf, 'tag', '128'), 'value', 0);
	set(findobj(gcbf, 'tag', '256'), 'value', 1);
	
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

	% Truncation level
	h = findobj(gcbf, 'tag', 'level');
	s = get(h, 'string');
	i = get(h, 'value');
	level = eval(s{i});

	% Dimension
	if get(findobj(gcbf, 'tag', '64'), 'value')
	    N = 64;
	elseif get(findobj(gcbf, 'tag', '128'), 'value')
	    N = 128;
	elseif get(findobj(gcbf, 'tag', '256'), 'value')
	    N = 256;
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

	W = fwt2(A, h, g);
	i = find(abs(W) >= level * max(max(abs(W))));
	Wtr = zeros(size(W));
	Wtr(i) = W(i);
	mini = min(abs(W(i)));

	axes(findobj(gcbf, 'tag', 'nonzeros'))

	showoper(Wtr)
	nsgrid;
	set(gca, 'tag', 'nonzeros', 'xtick', []);
	drawnow

	% Testvector
	U = get(gcbf, 'userdata');
	if isfield(U, 'testvector')
	    y = U.testvector
	else
	    y = testvector(N);
	    U.testvector = y;
	    set(gcbf, 'userdata', U);	
	end

	axes(findobj(gcbf, 'tag', 'orig'))
	plot(y)
	axis tight
	set(gca, 'tag', 'orig', 'xtick', [])

	axes(findobj(gcbf, 'tag', 'exact'))
	exact = A * y;
	plot(exact)
	axis tight
	set(gca, 'tag', 'exact', 'xtick', [])

	axes(findobj(gcbf, 'tag', 'approx'))
	approx = ifwt1ns(nsmult(Wtr, fwt1ns(y, h, g)), h, g);
	plot(approx)
	axis tight
	set(gca, 'tag', 'approx', 'xtick', []);

	axes(findobj(gcbf, 'tag', 'error'))
	error = approx-exact;
	plot(error)
	axis tight
	set(gca, 'tag', 'error');

	L2err = norm(error);
	Linferr = norm(error,inf);
	s = 'Error';
	if norm(exact) > 0
		s = [s sprintf(' (L2: %g%%', 100*raund(L2err/norm(exact)))];
		s = [s sprintf(', Linf: %g%%)', 100*raund(Linferr/norm(exact,inf)))];
	end
	set(findobj(gcbf, 'tag', 'errortext'), 'String', s);

	% colorbar
	axes(findobj(gcbf, 'tag', 'colorbar'))
	image((2:size(colormap,1))');
	set(gca, 'tag', 'colorbar', 'yaxislocation', 'right', 'xtick', [], ...
		'ytick', [2 size(colormap,1)-1], ...
		'yticklabel', [raund(mini); raund(max(max(abs(W))))],...
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

function y = testvector(N)

y = randn(N,1);
y = conv(y, [1 4 6 4 1]);
y = y(3 : N+2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = raund(x)

if x > 0
	d = floor(log(x)/log(10));
	y = round(x/10^(d-1))*10^(d-1);
else 
	y = 0;
end

