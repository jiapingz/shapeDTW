function wmenu

% WMENU -- main menu to all wavelet packet demos
%
% Graphing:
%     wavdemo   - wavelets in 1D
%     wav2demo  - wavelets in 2D
%     wpdemo    - wavelet packets in 1D
%     wp2demo   - wavelet packets in 2D
%
% Wavelet packets:
%     wpsig     - signal analysis using wavelet packets
%     chrpdemo  - analysis of several different 'chirps' with wavelet packets
%     chrpcomp  - comparison of wavelets, wavelet packets, and FFT 
%
% Operators:
%     wavoperd  - representations of operators in wavelet bases
%     wpoperd   - representations of operators in wavelet packet bases
%     wavmultd  - fast matrix multiplication using wavelets
%
% Image processing:
%     imgdemo   - a very simple image processing demo
%
% See also WAVDEMO, WAV2DEMO, WPDEMO, WP2DEMO, WPSIG, CHRPDEMO, 
%     CHRPCOMP, WAVOPERD, WPOPERD, WAVMULTD, IMGDEMO.

% (C) 1997 Harri Ojanen

wmenuf;
fixpos
set(gcf, 'handlevisibility', 'callback');
