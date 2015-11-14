function w = bestbas2(w)

% BESTBAS2 -- selects the best two dimensional basis
%
% wnew = bestbas2(w)
%
% w         two dimensional wavelet packet structure
%
% wnew      new wavelet packet structure containing appropriate selections.
%
% See also COSTFN, SETCOSTF.

% (C) 1997 Harri Ojanen

N = size(w.wp, 1);
levels = size(w.wp,3);
m = totcost2(w);
w.sel = uint8(zeros(size(w.wp)));

%dots('bestbas2', levels)
 
for level = 1 : levels-1

    blks = wp2blks(N, level+1);

    delta = N / 2^level;
    if level == 1
        sel = zeros(N, N);
    else
        sel = sel | double(w.sel(:,:,level-1));
    end

    if level == 1
        [I,J] = find(m{1});
        for k = 1 : length(I)
            w.sel(I(k) : I(k)+delta-1, J(k) : J(k)+delta-1, level) ...
                 = uint8(ones(delta,delta));
        end

    else
        [I,J] = find(~sel & m{level});
        for k = 1 : length(I)
            w.sel(I(k) : I(k)+delta-1, J(k) : J(k)+delta-1, level) ...
                 = uint8(ones(delta,delta));
        end
    end

    %dots
end

w.sel(:,:,levels) = ~(sel | double(w.sel(:,:,levels-1)));
%dots(-1)
