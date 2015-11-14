% Wavelet packets
%
%
% Transforms:
%   wpa1      - one dimensional wavelet packet analysis
%   wps1      - one dimensional wavelet packet synthesis
%
% Visualization:
%   showwp    - shows wavelet packet coefficients (and many other things)
%               graphically
%   phasepln  - phase plane plot of wave packet coefficients
%
% Selecting bases and working with selections:
%   bestbase  - selects the best wavelet packet basis 
%   bestlevl  - selects the best (fixed) level
%   fixlevel  - selects a fixed level
%   wavbasis  - selects the wavelet basis
%   setcostf  - displays a menu for selecting the cost function
%   discard   - discards small coefficients from the selection
%
% Natural and sequency orders:
%   nattoseq  - wavelet packet coefficients from natural to sequency order
%   seqtonat  - wavelet packet coefficients from sequency to natural order
%
%
% The following general purpose subroutines may be of independent interest:
%   fcenter   - the center of a filter
%   bitrev    - bit reverses integers
%   gc        - gray code
%   igc       - inverse gray code
%   prodlog   - solves the equation n*2^n = m for integer n
%
%
% The following m-files are subroutines used by other functions and
% will probably not be called by the user
%   costfn    - cost function used to select the best basis
%   children  - scale and frequency indices of the two children of a subspace
%   parent    - returns the scale and frequency indices for the parent subspace
%   sfptoidx  - converts (scale,frequence,position) triples to array indices
%   idxtosfp  - transforms array indices to corresponding (s,f,p) triples

% (C) 1997 Harri Ojanen

