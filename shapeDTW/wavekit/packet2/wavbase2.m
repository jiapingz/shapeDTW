function w = wavbase2(w)

% WAVBASE2 -- selects the (two dimensional) wavelet basis
% 
% wout = wavbase2(w)

% (C) 1997 Harri Ojanen

w.sel = uint8(zeros(size(w.sel)));

N = size(w.sel,1);
for l = 1 : log2(N)
    delta = N / 2^l;
    w.sel(delta+1 : 2*delta, 1 : 2*delta, l) = uint8(ones(delta, 2*delta));
    w.sel(1 : delta, delta+1 : 2*delta, l) = uint8(ones(delta, delta));
end
w.sel(1,1,log2(N)) = uint8(1);
