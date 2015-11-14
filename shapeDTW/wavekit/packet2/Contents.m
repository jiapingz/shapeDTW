% Two dimensional wavelet packets
%  
%  
% Wavelet packet analysis and synthesis
%     wpa2      - two dimensional wavelet packet analysis
%     wps2      - two dimensional wavelet packet synthesis
%
% Selecting a basis
%     bestbas2  - selects the best two dimensional basis
%     bestlvl2  - selects the best (fixed) level
%     fixlvl2   - selects a fixed level
%     wavbase2  - selects the non-standard (two dimensional) wavelet basis
%
% Matrix multiplication
%     wpmult    - multiplication of a vector by a matrix using wavelet packets
%
% Visualization and demos
%     showwp2   - displays the selected wavelet packet basis graphically
%     showsel2  - shows the selected basis textually
%     wp2demo   - graphs of two dimensional wavelet packets
%
% Subroutines for the above
%     totcost2  - computes costs for all subspaces
%     wp2blk    - return one block from a wavelet packet structure
%     wp2blks   - indices for the upper left hand corner of all blocks
%     wp2chl    - indices for the child blocks
%     wp2grid   - draws a grid explaining the selected wavelet packet basis
%
% Other
%     isgraph2  - checks if a graph basis has been selected

% (C) 1997 Harri Ojanen
