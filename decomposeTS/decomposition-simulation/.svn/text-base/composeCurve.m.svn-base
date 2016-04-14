
function curve = composeCurve(nBasis, sFreq, sPts, sNP, sMag)
% compose a curve by combining several sin and cos curves
% inputs
%        nBasis - the number of basic sin and cos to compose the curve
%        sMag  - span of magnitude, e.g. [minMag maxMag]
%        sPts  - number of points in one period
%        sFreq - span of frequency, e.g. [minFreq, maxFreq]
%        sNP    - span of the number of periods, e.g. [minNP, maxNP]

% output
%        curve - simulated curve
    narginchk(0,5);
    
    if ~exist('nBasis', 'var') || isempty(nBasis)
        nBasis = 5;
    end
    
    if ~exist('sMag', 'var') || isempty(sMag)
        sMag = [1 3];
    end
    
    if ~exist('sFreq', 'var') || isempty(sFreq)
        sFreq = [1 10];
    end
    
    if ~exist('sPts', 'var') || isempty(sPts)
        sPts = 10;
    end
    
    if ~exist('sNP', 'var') || isempty(sNP)
        sNP = [50 80];
    end
    
%     nsegs = 10;
%     sMag = 5;
%     sFreq = [5 10];
%     sNP = [10 15];
    flag = randi(3);
%     flag = 3;

    
    oldMag = 0;
    curves = cell(nBasis,1);
 	gaps = zeros(nBasis,1);
    mags = zeros(nBasis,1);
    NPs = zeros(nBasis,1);
    fs = zeros(nBasis,1);
    labels = zeros(nBasis,1);
    for i=1:nBasis
         f = randi(sFreq);
         mag = randi(sMag);
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
    %     [~,icurve] = segsin(f,10, mag, len);
        iNP = randi(sNP);
        if flag == 1
            if randi(2) == 1
                [~,~, gap] = cosseg(f, randi(sPts), iNP, mag);
                labels(i) = 1;
            else
                [~,~, gap] = sinseg(f, randi(sPts), iNP, mag);
            end
        elseif flag == 2
            [~,~, gap] = cosseg(f, randi(sPts), iNP, mag);
        else 
            [~,~, gap] = sinseg(f, randi(sPts), iNP, mag);
        end
%         curves{i} = icurve;
         gaps(i) = gap;
        mags(i) = mag;
        NPs(i) = iNP;
        fs(i) = f;
        
    end
    
    minGap = min(gaps);
    lens = zeros(nBasis,1);
    for i=1:nBasis
        if flag == 1
            if labels(i) == 1
                [~,icurve] = cosseg2(fs(i), minGap, NPs(i), mags(i));
            else
                [~,icurve] = sinseg2(fs(i), minGap, NPs(i), mags(i));
            end
        elseif flag == 2
            [~,icurve] = cosseg2(fs(i), minGap, NPs(i), mags(i));
        else
            [~,icurve] = sinseg2(fs(i), minGap, NPs(i), mags(i));
        end
        curves{i} = icurve;
        lens(i) = length(icurve);
    end
    
    minLens = min(lens);
    for i=1:nBasis
        curves{i} = curves{i}(1:minLens);
    end
    curve = cell2mat(curves);
    curve = mean(curve,1);
%     curve = sum(curve,1);
    

    if nargout == 0
        figure; plot(curve);
    end
    
    
end