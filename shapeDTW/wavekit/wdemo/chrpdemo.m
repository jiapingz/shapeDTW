function chrpdemo(action)

% CHRPDEMO -- best basis wavelet packet analysis of chirps
%
% This demo uses best basis wavelet packets to analyze chirps, signals of 
% the form  sin(f(t) t),  where the frequency  f(t)  depends on  t.
% 
% The different chirps are:
%     - linear chirp of the form sin(a t^2), where the 
%     - faster linear chirp of the form sin(b t^2), where the 
%       constant  b  is large enough for aliasing to show up in the phase
%       plane plots.
%     - quadratic chirp of the from  sin(c t^3)
%     - cubic chirp of the from  sin(d t^4)
%     - cubic chirp of the from  sin(d t^4)
%     - linear combination of a linear and a cubic chirp of the form
%       1/3 sin(b t^2) + sin(d t^4).  Note how the different amplitudes 
%       are evident in the phase plane plots (through the different gray
%       levels).
% 
% See also WMENU, CHRPDEMO, WPSIG.

% (C) 1997 Harri Ojanen

if nargin < 1
    action = 'init';
end


switch action

    case 'init'

	chrpdemf;
	fixpos
	set(findobj(gcf, 'tag', 'linear'), 'value', 1);
	set(findobj(gcf, 'tag', 'low'), 'value', 1);

        axes(findobj(gcf, 'tag', 'chirp'));
	axis square
        xlabel('time')
        ylabel('amplitude')
        set(gca, 'xtick', [], 'ytick', []);

        axes(findobj(gcf, 'tag', 'phaseplane'));
	axis square
        xlabel('time')
        ylabel('frequency')
        set(gca, 'xtick', [], 'ytick', []);

	set(gcf, 'handlevisibility', 'callback');

    case 'linear'
	markchirp(action);    
	
    case 'faster'
	markchirp(action);    

    case 'quadratic'	
	markchirp(action);    

    case 'cubic'	
	markchirp(action);    

    case 'superposed'
	markchirp(action);    

    case 'low'
	markres(action);

    case 'high'
	markres(action);

    case 'compute'

	watchon;

	[h,g] = wavecoef('coi', 24);
	if get(findobj(gcbf, 'tag', 'low'), 'value')
	    t = 0:1/255:1;
	    d = 1;	
	else
	    t = 0:1/1023:1;
	    d = 4;	
	end

	if get(findobj(gcbf, 'tag', 'linear'), 'value')
            y = sin(2*pi*t.*(d*25*t));      % linear
	
	elseif get(findobj(gcbf, 'tag', 'faster'), 'value')
            y = sin(2*pi*t.*(d*190*t));      % faster linear

	elseif get(findobj(gcbf, 'tag', 'quadratic'), 'value')
            y = sin(2*pi*t.*(d*38*t.^2));   % quadratic

	elseif get(findobj(gcbf, 'tag', 'cubic'), 'value')
            y = sin(2*pi*t.*(d*38*t.^3));   % cubic

	elseif get(findobj(gcbf, 'tag', 'superposed'), 'value')
            y = sin(2*pi*t.*(d*125*t)) / 3;      % linear
            y = y + sin(2*pi*t.*(d*38*t.^3));   % cubic
        end
        
        axes(findobj(gcbf, 'tag', 'chirp'));
        plot(t,y)
	axis square
        xlabel('time')
        ylabel('amplitude')
        set(gca, 'xtick', [], 'ytick', [], 'tag', 'chirp');

        axes(findobj(gcbf, 'tag', 'phaseplane'));
	cla; hold on
	drawnow

        w = bestbase(wpa1(y, h, g));
        phasepln(w, h, g)
        xlabel('time')
        ylabel('frequency')

        watchoff;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function markchirp(name)

markradio('linear', name);
markradio('faster', name);
markradio('quadratic', name);
markradio('cubic', name);
markradio('superposed', name);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function markres(name)

markradio('low', name);
markradio('high', name);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function markradio(button, selection)

set(findobj(gcf, 'tag', button), 'value', strcmp(button, selection));