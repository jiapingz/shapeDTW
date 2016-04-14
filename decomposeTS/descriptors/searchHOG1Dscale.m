
function scale =  searchHOG1Dscale(traindata, smin, smax, nmaxIter)
    % make the gradient orientation approximately evenly distributed 
    narginchk(1,4);
    
    if ~exist('smin', 'var') || isempty(smin)
        smin = 1.0e-5;
    end
    
    if ~exist('smax', 'var') || isempty(smax)
        smax = 1.0e3;
    end
    
    if ~exist('nmaxIter', 'var') || isempty(nmaxIter)
        nmaxIter = 30;
    end
    
    
    % initialization
    iter = 0;
    while iter < nmaxIter
        iter
        nInitScales = 30;
        scales = linspace(smin, smax, nInitScales);
        en = zeros(1, nInitScales);

        for i=1:nInitScales
            en(i) = calcOrientationEntropy(traindata, scales(i));
        end

        [~, idx] = max(en);
        if idx > 1 && idx < nInitScales
            smin = scales(idx-1);
            smax = scales(idx+1);
        elseif idx == 1
            smin = scales(idx);
            smax = scales(idx+1);
        elseif idx == nInitScales
            smin = scales(idx-1);
            smax = scales(idx);
        end
        
        scale = scales(idx);
        iter = iter + 1;
    end
    

    
%     niter = 0;    
%     lpt = smin;
%     rpt = smax;
%     en = zeros(1,3);
%     mpt = 1;
%     while niter < nmaxIter
%         
%         niter
%         mpt = (lpt + rpt)/2;
%         
%         step = 0.9*mpt;
%         l_mpt = mpt - step;
%         r_mpt = mpt + step;
%         
%         
%         en(1) = calcOrientationEntropy(traindata, l_mpt);
%         en(2) = calcOrientationEntropy(traindata, mpt);
%         en(3) = calcOrientationEntropy(traindata, r_mpt);
%         
%         if en(1) < en(2) && en(2) < en(3)
%             lpt = mpt;
%         elseif en(1) > en(2) && en(2) > en(3)
%             rpt = mpt;
%         elseif ((en(1)-en(2))*(en(2)-en(3))) < 0
%             scale = mpt;
%             return;
%         end
%         
%         niter = niter + 1;
%         
%     end    
%     scale = mpt;
%     return;


end

function en = calcOrientationEntropy(traindata, x_scale)


    nbins = 8; % orientation with sign
    angles = linspace(-pi/2, pi/2, nbins+1);  
    
    %% search for scales
    nTrain = numel(traindata);
    orientation = zeros(nTrain,nbins);
    
    parfor i=1:nTrain
        iTraindata = traindata{i};
        iTraindata = iTraindata(:);
        p = calcOrientationPDF(iTraindata, x_scale);
        orientation(i,:) = p;        
    end
    
    orientation = sum(orientation);
    orientation = orientation/sum(orientation);
    pidx = orientation > 0;
    p    = orientation(pidx);
	en  =  sum(-p.*log2(p));
    
end

function p = calcOrientationPDF(sequence, x_scale)

    %% default orientation setting
    nbins = 8; % orientation with sign
    angles = linspace(-pi/2, pi/2, nbins+1);  
    p = zeros(1,nbins);


    sequence = sequence(:);
    len = length(sequence);        
    seq1 = sequence(1:len-2);
    seq2 = sequence(3:len);

    angs = atan2(seq2 - seq1,2*x_scale*ones(len-2,1));
    
    for i=1:len-2
        ang = angs(i);
        n = whichInterval(angles, ang);
        p(n) = p(n) + 1;
    end
 
        
end









