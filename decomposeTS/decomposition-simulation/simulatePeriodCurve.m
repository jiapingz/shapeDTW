
function [curve, seglens] = simulatePeriodCurve(nsegs, sMag, sFreq, sPts, sNP)
% simulate a curve
% inputs
%        nsegs - the number of segments
%        sMag  - span of magnitude, e.g. [minMag maxMag]
%        sPts  - number of points in one period
%        sFreq - span of frequency, e.g. [minFreq, maxFreq]
%        sNP    - span of the number of periods, e.g. [minNP, maxNP]

%%      Note: sFreq is useless for the simulation, and the most important
%              parameter to control the frequency is the number of points
%              in each period

% output
%        curve - simulated curve
    narginchk(0,5);
    
    if ~exist('nsegs', 'var') || isempty(nsegs)
        nsegs = 10;
    end
    
    if ~exist('sMag', 'var') || isempty(sMag)
        sMag = [1 5];
    end
    
    if ~exist('sFreq', 'var') || isempty(sFreq)
        sFreq = [1 10];
    end
    
    if ~exist('sPts', 'var') || isempty(sPts)
        sPts = [3 60];
    end
    
    if ~exist('sNP', 'var') || isempty(sNP)
        sNP = [10 12];
    end
    
%     nsegs = 10;
%     sMag = 5;
%     sFreq = [5 10];
%     sNP = [10 15];

    curve = [];
    seglens = [];
%     oldMag = 0;
    oldnPts = 0;
    for i=1:nsegs
         f = randi(sFreq);
         mag = randi(sMag);
         nPts = randi(sPts);
        %{
        if i==1
            oldMag = mag;
        else
            while mag == oldMag
                mag = randi(sMag);                
            end
            oldMag = mag;
        end
        %}
         
        
        if i==1
            oldnPts = nPts;
        else
            while abs(nPts-oldnPts) <= 20
                nPts = randi(sPts);                
            end
            oldnPts = nPts;
        end
        
         
         
    %     [~,icurve] = segsin(f,10, mag, len);
        if randi(2) == 1
            [~,icurve] = cosseg(f, nPts, randi(sNP), mag);
        else
            [~,icurve] = cosseg(f, nPts, randi(sNP), mag);
        end
        curve = cat(2, curve, icurve);
        seglens = cat(2, seglens, length(icurve));
     end

    if nargout == 0
        figure; plot(curve);
    end

end