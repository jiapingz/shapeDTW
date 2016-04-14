function [x,y,gap] = sinseg(f, pts, nP, mag)
% simulate a cos segment
% inputs:
%        f      - frequency
%        pts    - points in one period
%        np     - the number of periods
%        mag    - magnitude
 
    period = 2*pi/f;    
%     gap = 1/period;
    gap = period/pts;
    x = 0:gap:(nP*period);    
    y = mag*sin(f*x);
end