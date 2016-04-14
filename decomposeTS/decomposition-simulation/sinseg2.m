function [x,y] = sinseg2(f, gap, nP, mag)
% simulate a sin segment
% inputs:
%        f      - frequency
%        gap    - sampling rate
%        np     - the number of periods
%        mag    - magnitude
 
    period = 2*pi/f;    
%     gap = 1/period;
%     gap = period/pts;
%     gap = period/10;
    x = 0:gap:(nP*period);    
    y = mag*sin(f*x);
end