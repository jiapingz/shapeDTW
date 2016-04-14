function [x,y,gap] = cosseg(f, pts, nP, mag)
% simulate a cos segment
% inputs:
%        f      - frequency
%        pts    - points in one period
%        np     - the number of periods
%        mag    - magnitude
 
    period = 2*pi/f;    
%     gap = 1/period;
    gap = period/pts;
%     gap = period/10;
    x = 0:gap:(nP*period);    
    y = mag*cos(f*x);
end