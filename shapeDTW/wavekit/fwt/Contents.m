% Wavelet transforms
%
%     fwt1      - fast wavelet transform, one dimensional standard version
%     fwt1ns    - fast wavelet transform, one dimensional non-standard version
%     fwt2      - two dimensional fast wavelet transform
%     fwt2ns    - fast wavelet transform, two dimensional, non-standard form
%                    (like fwt2 but with some extra features)
%     fwt2tns   - two dimensional fast wavelet transform (tensor product basis)
%     ifwt1     - inverse fast wavelet transform, standard version
%     ifwt1ns   - inverse fast wavelet transform, non-standard version
%     ifwt2     - two dimensional inverse wavelet transform
%     ifwt2tns  - inverse transform in a tensor product basis (2 dim)
% 
%     dilation  - solution to a dilation equation
%     waveletd  - construct a wavelet from the solution to a dilation equation
%
%     wavecoef  - returns some wavelet filter coefficients
%     selwavlt  - select wavelet filter coefficients from a menu
% 
% Visualization
%     showmsa   - show information on different levels of a multiscale analysis
%     shownsms  - show different levels of a non-standard multiscale analysis
%     showoper  - displays the matrix of an operator graphically
%     phasepl   - graphical phaseplane representation of wavelet transform
% 
%     nsgrid    - draws a grid explaining the partition of a packed ns-matrix
%     tnsgrid   - grid explaining the partition of a tensor product matrix
% 
% Utilities
%     nsmult    - multiply an operator with a non-standard msa
% 
%     nstomsa   - converts a nonstandard msa to a standard one
% 
%     lastlvl   - index of the last level in a (standard) msa
%     lastnslv  - index of the last level in a nonstandard msa
%     msalvl    - extract one multiscale level
%     nsmsalvl  - extract one multiscale level (nonstandard version)
%     msaidx    - computes the indices of a block in a (standard) msa
%     nsmsaidx  - computes the indices of a block in a nonstandard msa
% 
%     isstdmsa  - returns 1 if the argument is a standard msa
%     isnsmsa   - returns 1 if the argument is a nonstandard msa
%
%     makemex   - compile fast wavelet transform mex files 

% (C) 1993-1997 Harri Ojanen
