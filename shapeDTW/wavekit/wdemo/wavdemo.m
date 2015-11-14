function [outh, outg, outh2, outg2] = wavdemo(h,g,h2,g2)

% WAVDEMO -- graph different wavelets and scaling functions
%
% wavdemo
% [h,g] = wavdemo
% [h1,g1,h2,g2] = wavdemo
%
% This program presents the user with a menu of different wavelets
% and then displays the selected wavelet (and scaling function).
% If the output arguments are present the filter coefficients for 
% the last selection are returned when the user closes the window.
%
% wavdemo(h)
% wavdemo(h,g)
% wavdemo(h1,g1,h2,g2)
%
% This forms display the wavelet and scaling function arising from the
% filter coefficients h and g. No menu is presented.
%
% [x,s,w] = wavdemo(h)
% [x,s,w] = wavdemo(h,g)
% [x,s,w] = wavdemo(h,g,h1,g1)
%
% x  contains x-values,  s  is the values of the scaling function,
% w  the values of the wavelet.
%
% See also WMENU, WAVECOEF, SELWAVLT, WPDEMO, DILATION, WAVELETD.

% (C) 1997 Harri Ojanen

if ~(any(nargout == [0 2 3 4]) & any(nargin == [0 1 2 4]))
	error('Invalid number of arguments. See help wavdemo.')
end
Nargin = nargin;

if Nargin == 1
    [h,g] = wavecoef(h);
    Nargin = 2;
end

if Nargin > 0
    [s,x] = dilation(h, 8, [], 1);
    if Nargin == 4
        [s2,x] = dilation(h2, 8, [], 1);
    end
    if length(s)
        f = waveletd(s, x, g);
        if Nargin == 4
            f2 = waveletd(s2, x, g2);
        end
    else
        w = zeros(2046,1); w(63)=1; f=ifwt1ns(w,h,g);
        w = zeros(2046,1); w(95)=1; s=ifwt1ns(w,h,g);
        x = 0 : length(f)-1;    
        if Nargin == 4
            w = zeros(2046,1); w(63)=1; f2=ifwt1ns(w,h2,g2);
            w = zeros(2046,1); w(95)=1; s2=ifwt1ns(w,h2,g2);
        end
    end
    if nargout == 3
	outh = x(:);
	if Nargin == 2
            outg = s(:);
	    outh2 = f(:);
	else
            outg = [s(:) f2(:)];
	    outh2 = [w(:) f2(:)];
	end
    else
        if Nargin == 2
            subplot(211), plot(x,s), title('Scaling function')
    	    axis tight
            subplot(212), plot(x,f), title('Wavelet')
	    axis tight
        else
            subplot(211), plot(x,s,x,s2), title('Scaling function')
	    axis tight
            subplot(212), plot(x,f,x,f2), title('Wavelet')
	    axis tight
	end
    end
	
elseif nargout > 0

    fig = wavdemoc(nargout == 4);	
    uiwait(fig);
    U = get(fig, 'userdata');
    outh = U.h;
    outg = U.g;
    outh2 = U.h2;
    outg2 = U.g2;
    close(fig);

else

    wavdemoc(1);
    
end

