
function hog1dFileName = validateHOG1DFileName(sampling_method, seqlen, stride, ...
                                                    hog1d_param, activeAxis)
    
    if nargin == 0
        sampling_method = 'hybrid';
        seqlen = 52;
        stride = 25;        
        hog1d_param = validateHOG1Dparam;
        activeAxis = 'Y';
        seqFileName = ...
                generateSeqFileName(sampling_method, seqlen, stride);
    elseif nargin == 3
        seqFileName = generateSeqFileName(sampling_method, seqlen, stride);
        hog1d_param = validateHOG1Dparam;
        activeAxis = 'Y';
    elseif nargin == 4
        seqFileName = generateSeqFileName(sampling_method, seqlen, stride);
        hog1d_param = validateHOG1Dparam(hog1d_param);
        activeAxis = 'Y';
    elseif nargin == 5
        seqFileName = generateSeqFileName(sampling_method, seqlen, stride);
        hog1d_param = validateHOG1Dparam(hog1d_param);
    else
        error('Please input either 0,3,4 or 5 parameters\n');
    end
    

    hog1dFileName = sprintf('%s-HOG1D-nblocks-%d-nbins-%d-xScale-%.2f-activeAxis-%s.mat', ...
                                seqFileName(1:end-4),hog1d_param.blocks(2), hog1d_param.nbins, ...
                                hog1d_param.xscale, activeAxis); 

end