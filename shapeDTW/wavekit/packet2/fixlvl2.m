function w = fixlvl2(w,level)

% FIXLVL2 -- selects a fixed level
%
% wout = fixlvl2(w, level)
%
% w       wavelet packet structure from  wpa2
% level:  1 the first multiresolution level after the original data, etc.
%
% wout    new wavelet packet structure with the selections marked in it.

% (C) 1997 Harri Ojanen

w.sel = uint8(zeros(size(w.sel)));
w.sel(:,:,level) = uint8(ones(size(w.sel,1),size(w.sel,2)));
