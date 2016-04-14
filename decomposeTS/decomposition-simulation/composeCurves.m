function [curve, seglens] = composeCurves(nsegs, nBasis, sFreq, sPts, sNP, sMag)
    narginchk(0,6);
    
    if ~exist('nsegs', 'var') || isempty(nsegs)
        nsegs = 5;
    end
    
    if ~exist('nBasis', 'var') || isempty(nBasis)
        nBasis = 5;
    end
    
    if ~exist('sMag', 'var') || isempty(sMag)
        sMag = [1 2];
    end
    
    if ~exist('sFreq', 'var') || isempty(sFreq)
        sFreq = [1 10];
    end
    
    if ~exist('sPts', 'var') || isempty(sPts)
        sPts = [5 20];
    end
    
    if ~exist('sNP', 'var') || isempty(sNP)
        sNP = [80 150];
    end
    
    new_sFreq = [sFreq(1)+4 sFreq(end)-4];
    curve = [];
    seglens = [];
    oldf = 0;
    for i=1:nsegs
        iPts = randi(sPts);
        i_sFreq = randi(new_sFreq);
        
%         if i==1
% %             i_sFreq = randi(new_sFreq);
%             oldf = i_sFreq;
%         else
%             while abs(oldf - i_sFreq) < 4
%                 i_sFreq = randi(new_sFreq);
%             end
%             oldf = i_sFreq;
%         end
        
        
        icurve = composeCurve(nBasis, sFreq, iPts, sNP, sMag);
        curve = cat(2, curve, icurve);
        seglens = cat(2, seglens, length(icurve));
    end
    
    
    if nargout == 0
        figure; plot(curve);
    end

end