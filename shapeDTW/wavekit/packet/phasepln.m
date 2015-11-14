function phasepln(A1, A2, A3, A4, AA5)

% PHASEPLN -- phase plane plot of wave packet coefficients
%
% phasepln(w, issequencyorder, centerh, centerg)
% phasepln(w, issequencyorder)
% phasepln(w, centerh, centerg)
%
% w          wavelet packet coefficients from wpa1
% issequencyorder    
%            1, if the coefficients in w and selection are already
%            in sequency order, 0 otherwise (optional; default 0, 
%            i.e., natural order)
% centerh    the center of the h filter that was used in wpa1
% centerg    the center of the g filter that was used in wpa1
%            Both of these can also be the original filter coefficients,
%            then the centers are automatically calculated. (They are also
%            both optional, but the default value of 0 will usually not
%            produce accurate pictures.)
%
% All forms may be followed by one of the following options:
%     'edges'        draws edges to the time-frequency boxes
%     'blankedges'   draws the edges in the background color
% (The default behaviour is to leave out the edges of the boxes.)
%
% If the figure has a black background, before printing the command
% colormap(1-colormap) swaps dark and light shades.
%
% See also SHOWWP, NATTOSEQ, SEQTONAT.

% (C) 1997 Harri Ojanen

% Check the possible string argument

showedges = 0;
if isstr(eval(['A' num2str(nargin)]))
    if strcmp(eval(['A' num2str(nargin)]), 'edges')
        showedges = 1;
    elseif strcmp(eval(['A' num2str(nargin)]), 'blankedges')
        showedges = -1;
    else
        error('unknown option');
    end
    Nargin = nargin-1;    % the number of real arguments is one less
else
    Nargin = nargin;
end

w = A1;

if Nargin == 2
    issequencyorder = A2;
    centerh = 0; 
    centerg = 0;
elseif Nargin == 3    
    issequencyorder = 0;
    centerh = A2;
    centerg = A3;
else
    issequencyorder = A2;
    centerh = A3;
    centerg = A4;
end

if ~issequencyorder
    w = nattoseq(w);
end

if length(centerh) > 1, centerh = fcenter(centerh); end
if length(centerg) > 1, centerg = fcenter(centerg); end

w.wp = w.wp .* double(w.sel);
n = prodlog(length(w.wp));
N = 2^n;


% First figure out the background color

newplot;
if strcmp(get(gca,'color'), 'none')
    bgcolor = get(gcf,'color');
else
    bgcolor = get(gca,'color');
end


% Then a color which has sufficient to contrast to the background

if strcmp(version, '4.2c')     
    if sum(bgcolor) > 1.5
        edgecolor = [1 1 1]*0.99;   % this is due to a bug in 4.2c, can't
    else                            % use [1 1 1] or [0 0 0] properly
        edgecolor = [0 0 0]+0.01;    
    end
else
    if sum(bgcolor) > 1.5
        edgecolor = [1 1 1];
    else
        edgecolor = [0 0 0];
    end
end


% Now modify the above color according to given options

if showedges == 0 & ~(strcmp(computer, 'PCWIN') & strcmp(version, '4.0'))
    edgecolor = 'none';       % 4.0 has a bug: 'none' doesn't work properly
elseif showedges == 1
    edgecolor = 1-edgecolor;
end


%fill([0 N N 0], [0 0 N N], bgcolor)
%cla
hold on

phaseaux(w.wp, double(w.sel), 1, 1, n, N, centerh, centerg, edgecolor);
phaseaux(w.wp, double(w.sel), 1, 2, n, N, centerh, centerg, edgecolor);
plot([0 N N 0 0], [0 0 N N 0], 'color', 1-bgcolor);

hold off
if max(abs(w.wp)) > 0, caxis([0 max(abs(w.wp))]), end


% On a light background, use a colormap where large entries in w
% are drawn in dark colors, and vice versa.

if sum(bgcolor) > 1.5
    colormap(1-gray)
else
    colormap(gray)
end

%axis off
axis square
axis([0 N 0 N])
set(gca,'xtick',[])    
set(gca,'ytick',[])



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function phaseaux(w, selection, scale, freq, n, N, centerh, centerg, edgecolor)

% phaseaux -- used by phasepln to recursively draw the time-frequency boxes
%
% phaseaux(w, selection, scale, freq, n, N, centerh, centerg, edgecolor)
%
% This program is not meant to be called by the user.
%
% See also PHASEPLN.

idx = sfptoidx(scale, freq, N);

if any(selection(idx))
    width = 2^scale;
    height = N/width;
    correction = width * floor(abs( ...
        (1-1/width) * centerh + ...
        (centerg-centerh) * bitrev(gc(freq-1), scale)/width));
    y = 2^(-scale) * N * (freq-1);
    for p = 1 : length(idx)
        if selection(idx(p))
            x = rem((p-1)*width + correction, N);
            fill([x x+width x+width x], [y y y+height y+height], ...
                abs(w(idx(p))), 'edgecolor', edgecolor);
        end
    end
elseif scale < n
    [ls, lf, rs, rf] = children(scale, freq);
    phaseaux(w, selection, ls, lf, n, N, centerh, centerg, edgecolor);
    phaseaux(w, selection, rs, rf, n, N, centerh, centerg, edgecolor);
end



