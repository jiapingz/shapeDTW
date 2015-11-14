function showwp(P1, P2, P3, P4)

% SHOWWP -- shows wavelet packet coefficients and many other things
%
% showwp(w, h, g)
% showwp(w, f, h, g)
% 
% Displays the tree of the wavelet packet coefficients in w. f is
% the original vector (possibly an empty vector). If any selections
% are made, the selected packets are made to stand out. Both f and
% selection are optional.
% 
% The display is divided into two parts: in the top part is the tree
% of the wavelet packet coefficients, the bottom part is used for
% graphing other things.
% 
% The original vector is the very first row of the tree. Here white
% means large values, black small (possibly) negative values.
% 
% The wavelet packet coefficients form the rest of tree. The left
% branches are the result of convolution-decimation with the low
% pass filter (scaling function), right branches with the high pass
% filter (wavelet). Here only the absolute values of the
% coefficients are drawn: white means large absolute value, black
% means zero.
% 
% Clicking in a box on the first row shows the original vector,
% clicking in any other box shows the graph of the wavelet packet
% corresponding to that box.
% 
% Select menu:
%     Packet          toggle the selected/unselected state of a 
%                     single packet
%     Group           toggle the selected/unselected state of a box
%     Fixed level     click anywhere in the tree to select a level
%     Wavelet basis   selects the wavelet basis
%     Best level      selects the level with lowest cost
%     Best basis      selects the basis with lowest cost
%     Clear           clears all selections
% 
% Action menu:
%     Inverse transform    computes the inverse transform using 
%                          current selection
%     Phaseplane plot      displays the phaseplane plot for the 
%                          currently selected basis
%     Nonincreasing rearrengement
%                          displays the nonincreasing rearrengement
%                          of the wavelet packet coefficients
%     Compute cost         displays the cost of various things
% 
% Discard menu:
%     Discards all coefficients whose absolute value is less than the
%     selected percentage of the L2-norm of the whole collection of 
%     wavelet packet coefficients.
% 
% Options menu:    
%     Set cost function      allows to select the cost function
%     Show cost function     shows which cost function is being used
%     Natural order          switches the display to natural order
%     Sequency order         switches the display to sequency order
%     --> Color              switches the display to color
%     --> B/W                switches the display to black and white
% 
% See also PHASEPLN, WMENU, WPDEMO, WPA1, WPS1, BESTBASE, BESTLEVL, FIXLEVEL, WAVBASIS. 
 
% % (C) 1997 Harri Ojanen

%%% Different variations of input parameters

if nargin == 4
    action = 'init';
    w = P1;
    n = prodlog(length(w.wp),1);
    f = P2(:);
    if ~length(f), f = zeros(2^n,1); end
    h = P3;
    g = P4;
elseif nargin == 3
    action = 'init';
    w = P1;
    n = prodlog(length(w.wp),1);
    f = zeros(2^n,1);
    h = P2;
    g = P3;
elseif nargin == 2
    action = P1;
    arg = P2;
elseif nargin == 1
    action = P1;
    if ~ischar(action)
	error('Incorrect argument. See help showwp');
    end	
    arg = [];
else
    error('Incorrect number of arguments. See help showwp');
end

if ~strcmp(action, 'init')
    watchon;
end

if nargin >= 3
    selection = double(w.sel);

    %%% Scale the wavelet packet coefficients and the function
    
    W = zeros(2^n,n);
    W(:) = abs(w.wp(:));
    maxW = max(W(:));
    if maxW > 0, W = W/maxW; end

    F = f - min(f);
    maxF = max(F);
    if maxF > 0, F = F/maxF; end
    W = [F(:) W];

else

    thisfig = gcbf;
    U = get(gcbf, 'UserData');
    w = U.w;
    n = U.n;
    selection = U.selection;
    f = U.f;
    h = U.h;
    g = U.g;
    textcolor = U.textcolor;
    bgcolor = U.bgcolor;
    selectedcolor = U.selectedcolor;
    unselectedcolor = U.unselectedcolor;
    deltax = U.deltax;
    deltay = U.deltay;
    X = U.X;
    Y = U.Y;
    C = U.C;
    handle = U.handle;
    naturalorder = U.naturalorder;
    mode = U.mode;
	
end




switch action

    case 'init'

        showwpf
	fixpos
	thisfig = gcf;
        drawnow
	watchon;
	subplot(211);

        %global COSTFN
        %COSTFN = 2000;


        %%% Colors for selected and unselected boxes

	if strcmp(computer, 'PCWIN') & strcmp(version, '4.0')
	    unselectedcolor = [1 1 1]/4;
	    selectedcolor = [1 1 0];
	else
	    unselectedcolor = [1 1 1]/2;
	    selectedcolor = [1 0.25 0.25];
	end


	%%% Draw the tree

	deltay = 0.4;
	deltax = 0.4;
	y = 0;
	X = [];
	Y = [];
	C = [];

	centers = [];

	for level = 0:n
	    blocklength = 2^(n-level);
	    x = blocklength * deltax/2;
	    newcenters = [];
	    for block = 1 : blocklength : (2^n-blocklength+1)
	        b = W(block : block+blocklength-1, level+1);
	        for i = 1:length(b)
	            X = [X; x x+0.9 x+0.9 x];
	            Y = [Y; y y y+1 y+1];
	            C = [C b(i)];
	            x = x + 1;
	        end
	        newcenters = [newcenters x-blocklength/2];
	        if length(centers)
	            if strcmp(get(gca,'nextplot'), 'replace'), hold on,end
	            plot([x-blocklength/2 ...
	                  centers(floor(((block-1)/blocklength)/2)+1)], ...
	                [y+1 y+1+deltay], 'color', unselectedcolor);
	        end
	        x = x + blocklength * deltax;
	    end
	    centers = newcenters;
	    y = y - 1 - deltay;
	end

	X = X'; Y = Y';
	handle = fill(X,Y,C);
	set(handle,'edgecolor',unselectedcolor);
	if any(selection)
	    set(handle(find(selection)+2^n),'edgecolor',selectedcolor);
	end

	%callbacks = cell(length(handle),1);
	for i = 1 : length(handle)
	    %callbacks{i} = ['showwp(''box'',' num2str(i) ')'];
	    set(handle(i),'ButtonDownFcn', ['showwp(''box'',' num2str(i) ')']);
	end
	%set(handle, {'ButtonDownFcn'}, callbacks);


	%%% Set axis

	axis([min(X(:)) max(X(:)) min(Y(:)) max(Y(:))]);
	if strcmp(computer,'PCWIN') & strcmp(version, '4.0')
	    axis off
	else
            axis on
            set(gca,'xtick',[],'ytick',[]);
            set(gca,'ycolor',get(gcf,'color'));
            set(gca,'xcolor',get(gcf,'color'));
            ax = axis;
            ax(3) = ax(3) - deltay/2;
            axis(ax)
	end


	%%% Choose textcolor so that there is enough contrast between text
	%%% and backgrnd

	if strcmp(get(gca,'color'), 'none')
	    bgcolor = get(gcf,'color');
	else
	    bgcolor = get(gca,'color');
	end
	if sum(bgcolor) > 1.5
	    textcolor = [0 0 0];
	    colormap(1-gray)
	else
	    textcolor = [1 1 1];
	    colormap(gray)
	end


	%%% Make axis background the same color as figure background

	set(gca, 'color', get(gcf, 'color'))
	
	hold off


	title('Original vector and wavelet packet coefficients (natural order)')
	%shwpmsg('Click on a box or press q to quit or h for help',textcolor)


	set(findobj(gcf, 'tag', 'natural'), 'checked', 'on');


	mode = '';
	naturalorder = 1;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



    case 'help'


        if exist('helpwin')    
            eval('helpwin showwp')     % for 5.0
        elseif exist('hthelp')   
            eval('hthelp showwp')      % for 4.2
        else                
            eval('help showwp')        % and even older
        end
	clearmode(thisfig, mode);
	mode = '';
	shwpmsg('',textcolor);

    %%% Phase plane plot

    case 'phaseplane'

        subplot(212)
        phasepln(makewp(w, selection), ~naturalorder, h, g);
        title('Phaseplane')
        xlabel('time');ylabel('frequency');

	clearmode(thisfig, mode);
	mode = '';
	shwpmsg('',textcolor);
        

    %%% Switch ordering

    case 'sequency'

	subplot(211);
        w = nattoseq(w);
        selection = nattoseq(selection);
        C(2^n+1 : length(C)) = nattoseq((C(2^n+1 : length(C)))')';
        title(...
	    'Original vector and wavelet packet coefficients (sequency order)')
	set(findobj(thisfig, 'tag', 'sequency'), 'checked', 'on');
	set(findobj(thisfig, 'tag', 'natural'), 'checked', 'off');

        hold on
        delete(handle)
        handle = fill(X,Y,C);
        hold off
        set(handle, 'edgecolor', unselectedcolor);
        set(handle(find(selection)+2^n), 'edgecolor', selectedcolor);
        naturalorder = ~naturalorder;
	for i = 1 : length(handle)
	    set(handle(i),'ButtonDownFcn', ['showwp(''box'',' num2str(i) ')']);
	end

	clearmode(thisfig, mode);
	mode = '';
	shwpmsg('',textcolor);


    case 'natural'

	subplot(211);
        w = seqtonat(w);
        selection = seqtonat(selection);
        C(2^n+1 : length(C)) = seqtonat((C(2^n+1 : length(C)))')';
        title(...
	    'Original vector and wavelet packet coefficients (natural order)')
	set(findobj(thisfig, 'tag', 'natural'), 'checked', 'on');
	set(findobj(thisfig, 'tag', 'sequency'), 'checked', 'off');

        hold on
        delete(handle)
        handle = fill(X,Y,C);
        hold off
        set(handle, 'edgecolor', unselectedcolor);
        set(handle(find(selection)+2^n), 'edgecolor', selectedcolor);
        naturalorder = ~naturalorder;
	for i = 1 : length(handle)
	    set(handle(i),'ButtonDownFcn', ['showwp(''box'',' num2str(i) ')']);
	end

	clearmode(thisfig, mode);
	mode = '';
	shwpmsg('',textcolor);


    %%% Select a fixed level

    case 'fixedlevel'

	clearmode(thisfig, mode);
	mode = action;
	markmode(thisfig, mode);
	shwpmsg('Click in the tree to select a level', textcolor)


    %%% Select the best basis

    case 'bestbasis'

        w = bestbase(w, f);
	selection = double(w.sel);
        set(handle(find(selection)+2^n),'edgecolor',selectedcolor);
        set(handle(find(~selection)+2^n),'edgecolor',unselectedcolor);

	clearmode(thisfig, mode);
	mode = '';
	shwpmsg('Best basis selected',textcolor);


    %%% Select the best level

    case 'bestlevel'

        [w, level] = bestlevl(w);
	selection = double(w.sel);
        set(handle(find(selection)+2^n),'edgecolor',selectedcolor);
        set(handle(find(~selection)+2^n),'edgecolor',unselectedcolor);

	clearmode(thisfig, mode);
	mode = '';
	shwpmsg(sprintf('Level %i selected', level),textcolor);


    %%% Select wavelet basis

    case 'waveletbasis'

	w = wavbasis(w);
	selection = double(w.sel);
        set(handle(find(selection)+2^n),'edgecolor',selectedcolor);
        set(handle(find(~selection)+2^n),'edgecolor',unselectedcolor);

	clearmode(thisfig, mode);
	mode = '';
	shwpmsg('Wavelet basis selected',textcolor);


    %%% Discard small selected entries

    case 'drop'	

	subplot(211);
        i = find(selection);
        threshold = arg;
        drop = i(find(abs(w.wp(i)) < threshold * norm(w.wp,2)));
        set(handle(drop+2^n), 'edgecolor', unselectedcolor);
        selection(drop) = zeros(size(drop));
        str = sprintf(['Dropped %i coefficients (criteria: less than ' ...
                       '%g%% of norm), kept %i'], ...
             length(drop), 100*threshold, sum(selection));
        shwpmsg(str,textcolor)
        %fprintf('%s\n', str)

	clearmode(thisfig, mode);
	mode = '';


    %%% Display entropy

    case 'entropy'

	clearmode(thisfig, mode);
	mode = action;
	markmode(thisfig, mode);
	shwpmsg('Click in a group to see the cost', textcolor)


    %%% Clear selections

    case 'clear'
    
        selection = zeros(size(w.wp));
        shwpmsg('All selections cleared',textcolor);
        %fprintf('All selections cleared\n');
        set(handle,'edgecolor',unselectedcolor);

	clearmode(thisfig, mode);
	mode = '';


    %%% Select a subspace

    case 'group'

	clearmode(thisfig, mode);
	mode = action;
	markmode(thisfig, mode);
	shwpmsg('Click in a group to select it', textcolor)


    %%% Select an individual packet

    case 'packet'

	clearmode(thisfig, mode);
	mode = action;
	markmode(thisfig, mode);
	shwpmsg('Click in a packet to select it', textcolor)


    %%% Inverse transform with selected packets

    case 'inverse'

        if naturalorder
            F = wps1(makewp(w, selection), h, g);
        else
            F = wps1(makewp(seqtonat(w), seqtonat(selection)), h, g);
        end
        subplot(212)
        plot(1:2^n, f, ':', 1:2^n, F, '-');
        title(sprintf('Errors: Linf %g, L2 %g (dotted line is original)', ...
            norm(F-f,inf), norm(F-f,2)));
        %fprintf('Errors: Linf %g, L2 %g\n', norm(F-f,inf), norm(F-f,2));
        axis tight

	clearmode(thisfig, mode);
	mode = '';
	shwpmsg('',textcolor);
       

    %%% Show the nonincreasing rearrangement

    case 'rearrange'

        subplot(212);
        [sortw, sorti] = sort(abs(w.wp));
        sortw = sortw(length(sortw) : -1 : 1);
        sorti = sorti(length(sorti) : -1 : 1);
        if n <= 5
            [x, y] = bar(sortw);
            plot(x,y, 'color', unselectedcolor)
        else
            plot(1:length(sortw), sortw, 'color', unselectedcolor)
        end
        if any(selection)
            ii = find(selection);
            hold on
            for k = 1 : length(ii)
                j = find(sorti == ii(k));
                if n <= 5
                    [x,y] = bar(j,sortw(j));
                    plot(x,y, 'color', selectedcolor);    
                else
                    x1 = j;
                    x2 = min(j+1, length(sortw));
                    y1 = sortw(j);
                    y2 = sortw(min(j+1, length(sortw)));
                    fill([x1 x2 x2 x1], [0 0 y2 y1], ...
                        selectedcolor, 'edgecolor', selectedcolor)
                end
            end
            hold off
        end
        axis tight

	mode = action;
	markmode(thisfig, mode);
	shwpmsg('Click in a packet to see its position',textcolor);


    %%% Change between color and b/w modes

    case 'color'

	subplot(211);
	colorboxes;
	%markmode(thisfig, 'color');
	%clearmode(thisfig, 'bw');

    case 'bw'

	subplot(211);
	thickbwboxes;
	%markmode(thisfig, 'bw');
	%clearmode(thisfig, 'color');


    %%% Click in a box

    case 'box'


        %subplot(211)

        i = arg;
        [scale, freq, pos] = idxtosfp(i-2^n, 2^n);
        infostr = sprintf('[idx=%i; s=%i, f=%i, p=%i]', i-2^n, ...
            scale, freq, pos);

	switch mode

	    case ''	
	        if i <= 2^n     % click in the original vector, graph it
	            %fprintf('Original vector, entry %i = %g\n', i, f(i));
	            subplot(212)
	            if n < 5
        	        bar(f)
	            else
        	        plot(1:2^n, f, '-', i, f(i), 'o');
	                %ax = axis; ax(1) = 1; ax(2) = 2^n; axis(ax);
			axis tight
        	    end
	            title(sprintf('Original vector, entry %i = %g', i, f(i)));
            
	        elseif i > 2^n      % show the corresponding wavelet packet
	            i = i - 2^n;
	            ww = zeros(size(w.wp));
	            ww(i) = 1;
	            if ~naturalorder
	                ww = seqtonat(ww);
	            end
		    ww = struct('wp', ww, 'sel', uint8(ww));
	            packet = wps1(ww,h,g);
	            subplot(212)
	            if n <= 5
	                bar(packet)
	            else
	                plot(packet)
	                %ax = axis; ax(1) = 1; ax(2) = 2^n; axis(ax);
			axis tight
	            end
	            title(sprintf('Packet %s, coefficient %g', ...
				infostr, w.wp(i)));
	        end
		shwpmsg('',textcolor);


	    case 'packet'

		if ~selection(i-2^n)
                    %%% Select an individual packet
                    [scale, freq] = idxtosfp(i-2^n, 2^n);
                    [pscale, pfreq] = parent(scale, freq);
                    if anyparnt(pscale, pfreq, selection, 2^n)
                        shwpmsg('Cannot select, some parent is selected', ...
                            textcolor);
                    else
                        selection(i-2^n) = 1;
                        shwpmsg(...
			    sprintf('Packet %s selected, coefficient = %g', ...
                            infostr, w.wp(i-2^n)),textcolor);
                        set(handle(i),'edgecolor',selectedcolor);
                        % unselect all children
                        if scale < n
                            [ls, lf, rs, rf] = children(scale, freq);
                            selection = selection & ...
                                unselchl(ls, lf, n, handle, selection, 2^n, ...
                                    unselectedcolor) & ...
                                unselchl(rs, rf, n, handle, selection, 2^n, ...
                                    unselectedcolor);
                        end
                    end
    
                else    
	            %%% Unselect an individual packet
	            selection(i-2^n) = 0;
	            shwpmsg(sprintf('Packet %s unselected', infostr),...
			textcolor);
	            set(handle(i),'edgecolor',unselectedcolor);
	        end


	    case 'group'

		if ~selection(i-2^n)
      	            %%% Select a subspace
                    [scale, freq] = idxtosfp(i-2^n, 2^n);
                    [pscale, pfreq] = parent(scale, freq);
                    if anyparnt(pscale, pfreq, selection, 2^n)
                        shwpmsg('Cannot select, some parent is selected',...
                            textcolor);
                    else
                        idx = sfptoidx(scale, freq, 2^n);
                        shwpmsg(sprintf('Subspace s=%i, f=%i selected', ...
                            scale, freq), textcolor);
                        set(handle(idx+2^n), 'edgecolor', selectedcolor);
                        selection(idx) = ones(size(idx));
                        % unselect all children
                        if scale < n
                            [ls, lf, rs, rf] = children(scale, freq);
                            selection = selection & ...
                                unselchl(ls, lf, n, handle, selection, 2^n, ...
                                    unselectedcolor) & ...
                                unselchl(rs, rf, n, handle, selection, 2^n, ...
                                    unselectedcolor);
                        end
                    end

                else
		    %%% Unselect a subspace
	            [scale, freq] = idxtosfp(i-2^n, 2^n);
	            idx = sfptoidx(scale, freq, 2^n);
	            shwpmsg(sprintf('Subspace s=%i, f=%i unselected', ...
			scale, freq), textcolor);
	            set(handle(idx+2^n), 'edgecolor', unselectedcolor);
	            selection(idx) = zeros(size(idx));
	        end        


	    case 'fixedlevel'

		if i > 2^n
                    selection = zeros(size(w.wp));
                    set(handle, 'edgecolor', unselectedcolor);
                    [scale, freq] = idxtosfp(i-2^n, 2^n);
                    idx = sfptoidx(scale, 1, 1, 2^n);
                    idx = idx : idx + 2^n - 1;
                    set(handle(idx+2^n),'edgecolor',selectedcolor);
                    selection(idx) = ones(size(idx));
	            shwpmsg('',textcolor);
		else
	            shwpmsg('You may not select the original vector',...
			textcolor);
		end


	    case 'entropy'
	        if i <= 2^n
	            str=sprintf('The original vector has cost %g', costfn(f));
	            shwpmsg(str,textcolor)
	            %fprintf('%s\n',str)
	        else
	            [scale, freq] = idxtosfp(i-2^n, 2^n);
	            idx = sfptoidx(scale, freq, 2^n);
	            entr = costfn(w.wp(idx));
	            str = sprintf('Subspace s=%i, f=%i has cost %g',...
			scale, freq,entr);
	        end
	        if any(selection)
	            str = [str sprintf(', selection has cost %g', ...
	                costfn(w.wp(find(selection))))];
	        end
	        shwpmsg(str,textcolor)
	        %fprintf('%s\n',str)


	    case 'rearrange'
	        subplot(212);
	        i = i - 2^n;
	        [sortw, sorti] = sort(abs(w.wp));
	        sortw = sortw(length(sortw) : -1 : 1);
	        sorti = sorti(length(sorti) : -1 : 1);
	        j = find(sorti == i);
	        if length(j) > 0
	            hold on; plot(j,sortw(j),'o'); hold off
	            title(sprintf( ...
	                ['Nonincreasing rearrangement, ' ...
                         'packet %i, sorted index %i'], i, j));
	        end
	        shwpmsg('',textcolor)

        
	end    % switch mode

	clearmode(thisfig, mode);
	mode = '';


end    % switch action



U.w = w;
U.n = n;
U.selection = selection;
U.f = f;
U.h = h;
U.g = g;
U.textcolor = textcolor;
U.bgcolor = bgcolor;
U.selectedcolor = selectedcolor;
U.unselectedcolor = unselectedcolor;
U.deltax = deltax;
U.deltay = deltay;
U.X = X;
U.Y = Y;
U.C = C;
U.handle = handle;
U.naturalorder = naturalorder;
U.mode = mode;
    
set(thisfig, 'UserData', U);

watchoff;
set(thisfig, 'HandleVisibility', 'callback');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function markmode(fig, mode)

if length(mode)
    h = findobj(fig, 'Callback', ['showwp ' mode]);
    if length(h)
        set(h, 'checked', 'on');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function clearmode(fig, mode)

if length(mode)
    h = findobj(fig, 'Callback', ['showwp ' mode]);
    if length(h)
        set(h, 'checked', 'off');
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function thickbwboxes

% THICKBWBOXES -- selected boxes are changed into thick black or white lines

h = findobj(gca, 'type', 'patch', 'edgecolor', [1 0.25 0.25]);

for i = 1 : length(h)
    set(h(i), 'linewidth', 2.5);
    set(h(i), 'edgecolor', [0.01 0.01 0.01]);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function colorboxes

% COLORBOXES -- selected boxes are changed to have colored borders

h = findobj(gca, 'type', 'patch', 'edgecolor', [0.01 0.01 0.01]);

for i = 1 : length(h)
    set(h(i), 'linewidth', .5);
    set(h(i), 'edgecolor', [1 0.25 0.25]);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function w = makewp(w, selection)

w.sel = uint8(selection);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function flag = anyparnt(scale, freq, selection, N)

% anyparnt -- returns 1 if anything on this subspace or any parent is selected
%
% This program is not meant to be called by the user.
%
% flag = anyparnt(scale, freq, selection, N)
%
% See also SHOWWP.

% HO 5/1997

if scale < 1
    flag = 0;
else
    i = sfptoidx(scale, freq, N);
    if any(selection(i))
        flag = 1;
    else
        [pscale, pfreq] = parent(scale, freq);
        flag = anyparnt(pscale, pfreq, selection, N);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function selection = unselchl(scale, freq, n, handle, selection, N, unselectedcolor)

% UNSELCHL -- unselects given subspace and all children
%
% This program is not meant to be called by the user.
%
% selection = unselchl(scale, freq, n, handle, selection, unselectedcolor)
%
% See also SHOWWP.

% HO 5/1997

idx = sfptoidx(scale, freq, N);
i = idx(find(selection(idx)));
selection(i) = zeros(size(i));
set(handle(i+2^n),'edgecolor',unselectedcolor);
if scale < n
    [ls, lf, rs, rf] = children(scale, freq);
    selection = selection & unselchl(ls, lf, n, handle, selection, N,unselectedcolor) & ...
                            unselchl(rs, rf, n, handle, selection, N,unselectedcolor);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function showopt

% SHOWOPT -- displays the values of the options used by showopt
%
% This program is not meant to be called by the user.
%
% See also SHOWWP.
 

global COSTFN

if ~length(COSTFN)
    s = 'Cost function is not set';
elseif COSTFN < 1000
    s = sprintf('Cost function is Lp with p = %g', COSTFN);
elseif COSTFN == 1000
    s = sprintf('Cost function is entropy');
elseif COSTFN == 2000
    s = sprintf('Cost function is L2 entropy');
elseif COSTFN >= 3000 & COSTFN < 4000
    s = sprintf('Cost function is threshold with threshold = %g', COSTFN-3000);
else
    s = 'Unknown cost function?!';
end

if strcmp(get(gca,'color'), 'none')
    bgcolor = get(gcf,'color');
else
    bgcolor = get(gca,'color');
end
if sum(bgcolor) > 1.5
    textcolor = [0 0 0];
else
    textcolor = [1 1 1];
end

shwpmsg(s,textcolor)

