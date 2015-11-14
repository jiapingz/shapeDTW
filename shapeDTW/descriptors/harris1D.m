% use to detect peaks from noisy signals

% use the same idea as harris corner detector to get the peak points

% input
% t: time series
% win: window size to get the covariance matrix
% Q: QualityLevel
% K: SensitivityFactor

function varargout = harris1D(t, win, Q, K)
    if nargin < 2 || isempty(win)
        win = 5;
    end
    
    if nargin < 3 || isempty(Q)
        Q = 0.01;
    end
    
    if nargin < 4 || isempty(K)
        K = 0.04;
    end
    
    if isrow(t)
        dt = [0 diff(t)];
    elseif iscolumn(t)
        dt = [0; diff(t)];
    else
        error('input signal is confined to be 1D\n');
    end
    
    nt = length(t);
    R = zeros(nt,1);
    
    sidx = ceil(win/2);
    eidx = nt - ceil(win/2);
    
    mask = 1:win;
    mask = mask - ceil(win/2);
    dx = ones(size(mask));
    
    
    for i=sidx:eidx
        imask = mask + i;
        dy = dt(imask);        
        M = [dot(dx,dx) dot(dx,dy); dot(dy,dx) dot(dy,dy)];
        R(i) = det(M) - K * trace(M)^2;
    end
    
    
    [~, ind] = sort(R, 'descend');
    peakInds = ind(1:50);
    peakMags = t(ind(1:50));
    
    % Plot if no output desired
    if nargout == 0
        if isempty(peakInds)
            disp('No significant peaks found')
        else
            figure;
            plot(1:length(t),t,'.-',peakInds,peakMags,'ro','linewidth',2);
        end
    else
        varargout = {peakInds,peakMags};
    end
    
    
end