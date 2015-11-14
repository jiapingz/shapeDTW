function y = wpmult(A, x)

% WPMULT -- multiplication of a vector by a matrix using wavelet packets
%
% y = wpmult(A, x)
%
% A    the matrix in a wavelet packet representation (use  wpa2  and then
%          select a basis)
% x    the vector in a wavelet packet representation (use  wpa1)
%
% y    wavelet packet representation of  A*x
%
% See also WPA2, WPA1, WPS1, BESTBAS2.

% (C) 1997 Harri Ojanen

N = size(A.wp,1);
levels = log2(N);
y = zeros(N*levels,1);
sel = y;

%dots('wpmult', levels);

for level = 1 : levels
    delta = N / 2^level;	
    blks = wp2blks(N, level+1);
    for i = blks
        for j = blks
            if A.sel(i, j, level)
                yidx = sfptoidx(level, (j-1)/delta+1, N);
                y(yidx) = y(yidx) + A.wp(i:i+delta-1, j:j+delta-1, level) * ...
                    x.wp(sfptoidx(level, (i-1)/delta+1, N));
%                y(yidx) = y(yidx) + A.wp(i:i+delta-1, j:j+delta-1, level) *...
%                    x.wp(sfptoidx(level, (j-1)/delta+1, N));
                sel(yidx) = ones(delta,1); %*level;
            end
        end
    end
    %dots;
end

%dots(-1);
y = struct('wp', y, 'sel', uint8(sel));
