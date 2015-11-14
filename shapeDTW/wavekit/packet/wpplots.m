function [Wout,xout] = wpplots(h, g, Npackets, level)

% WPPLOTS -- computes and plots wavelet packets
%
% [W,x] = wpplots(h, g, Npackets, gridlevel)
%
% h,g        filter coefficients
% Npackets   number of wavelet packets to compute
% gridlevel  the functions will be computed on a grid where the points are
%            2^(-gridlevel)  units apart
%
% W   The columns of  W  are the values of the different wavelet packets,
% x   contains the x-coordinates corresponding to  W.
%     use e.g.,  plot(x,W(:,5))
%
% All arguments are optional, default values are:
% h,g         prompt the user with a menu of possible choices
% Npackets    16
% gridlevel   8
%
% Also allowed is  wpplots([],[],32,9)  to show the wavelet menu but still 
% get access to the other parameters.
%
% See also WAVDEMO.

% (C) 1997 Harri Ojanen

if nargin < 2, h = []; g = []; end
if ~length(h)
    [h,g] = selwavlt;
end
if nargin < 3, Npackets = 16; end
if nargin < 4, level = 8; end

[f,x] = dilation(h, level, [], 1);
if isempty(f)
    Wout = [];
    xout = [];
    return
end

Nmax = Npackets - 1;
W = zeros(length(f), Nmax+1);
W(:, 1) = f;

for i = 1 : Nmax
    if nargout == 0
        figure(gcf)
        plot(x,f)
        title(sprintf('%i (igc = %i)', i-1, igc(i-1)))
        ax = axis;
        ax(1) = min(x); ax(2) = max(x);
        if length(h) == 2
            % Haar wavelet(?), expand the picture for a better view
            ax(3) = min(0, ax(3) - 0.1*abs(ax(3)));
            ax(4) = max(0, ax(4) + 0.1*abs(ax(4)));
        end
        axis(ax)
        pause
    end

    if isodd(i)
        f = waveletd(W(:, (i-1)/2+1),x,g);
    else
        f = waveletd(W(:, i/2+1),x,h);
    end

    W(:, i+1) = f;
end

if nargout > 0, Wout = W; xout = x; end


