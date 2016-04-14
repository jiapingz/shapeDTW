
function symbolFileName = validateHOG1DSymbolFileName(sampling_method, seqlen, stride, ...
                                                    hog1d_param, activeAxis, useGyro, K)
                                                
	if nargin == 0
        sampling_method = 'hybrid';
        seqlen = 52;
        stride = 25;  
        useGyro = 0;
        K = 50;
        hog1d_param = validateHOG1Dparam;
        activeAxis = 'Y';
        seqFileName = ...
                generateSeqFileName(sampling_method, seqlen, stride);
    elseif nargin == 3
        seqFileName = generateSeqFileName(sampling_method, seqlen, stride);
        hog1d_param = validateHOG1Dparam;
        activeAxis = 'Y';
        useGyro = 0;
        K = 50;
    elseif nargin == 4
        seqFileName = generateSeqFileName(sampling_method, seqlen, stride);
        hog1d_param = validateHOG1Dparam(hog1d_param);
        activeAxis = 'Y';
        useGyro = 0;
        K = 50;
    elseif nargin == 5
        seqFileName = generateSeqFileName(sampling_method, seqlen, stride);
        hog1d_param = validateHOG1Dparam(hog1d_param);
        useGyro = 0;
        K = 50;
    elseif nargin == 6
        seqFileName = generateSeqFileName(sampling_method, seqlen, stride);
        hog1d_param = validateHOG1Dparam(hog1d_param);        
        K = 50;
    elseif nargin == 7
        seqFileName = generateSeqFileName(sampling_method, seqlen, stride);
        hog1d_param = validateHOG1Dparam(hog1d_param);  
    else
        error('Please input either 0,3,4, 5, 6, or 7 parameters\n');
    end
    

    symbolFileName = sprintf('%s-HOG1D-nblocks-%d-nbins-%d-xScale-%.2f-activeAxis-%s-useGyro-%d-K-%d-symbols.mat', ...
                                seqFileName(1:end-4),hog1d_param.blocks(2), hog1d_param.nbins, ...
                                hog1d_param.xscale, activeAxis, useGyro, K); 
                                                
                                                
                                                
end