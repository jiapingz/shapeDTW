% extract HOG1D in a multi-scale way
% multiscale may help to find distinctive pattern in the sensor signals

% sensordata should be 1D time series
% although in the raw recording, accelerometer and gyroscope data are
% arranged in a matrix, this function only accept column vector inputs
% that's taking one kind of observation each time

% at the same time, it's better to return raw sequences, which will help us
% to check the quality of the descriptor visually

function [hog1d_ms, sequences] = calcMultiScaleHOG1D(sensordata, param)
    % parameter setting
    
    %{
    param.hog1d.blocks        = [1 2];  % unit: cell
    param.hog1d.cells         = [1 25]; % unit: t
    param.hog1d.gradmethod    = 'centered'; % 'centered'
    param.hog1d.nbins         = 6;
    param.hog1d.sign          = 'true';
    param.sampling.seqlen        = 52;
    param.sampling.seqstride     = 25;
    param.ms.nlayers       = 3;
    param.ms.scales        = [1 1.5 2];
    %}
    
    % (1) first sample signal at different resolutions
    nlayers     = param.ms.nlayers;
    scales      = param.ms.scales;
    
    if length(scales) ~= nlayers
        error('Inconsistency found in the input parameters\n');
    end
    
    sequences   = cell(nlayers,1);    
    for i=1:nlayers
        if ~iscolumn(sensordata)
            error('Sensor data should be a column vector\n');
        end
        i_sensordata = imresize(sensordata,  [length(sensordata)/scales(i), 1]);
        seqlen = param.sampling.seqlen;
        stride = param.sampling.seqstride;
        sub_sequences = sampleSequencesEvenly(i_sensordata, seqlen, stride);
        sequences{i} = sub_sequences;
    end
    
    % take signals as 1D images, and use imresize to downsample the signals
    param_hog1d = param.hog1d;
    sCell       = param.hog1d.cells(2);
    nBlock      = param.hog1d.blocks(2);
    seqlen      = param.sampling.seqlen;
    cutoff = zeros(1,2);
    switch param.hog1d.gradmethod
        case 'centered'
            cutoff(1) = 2;
            cutoff(2) = cutoff(1) + sCell*nBlock - 1;
        case 'uncentered'
            cutoff(1) = 1;
            cutoff(2) = cufoff(1) + sCell*nBlock - 1;            
    end
    
    descriptors = cell(nlayers,1);
    
    for i=1:nlayers
        sub_sequences = sequences{i};
        nSeqs = size(sub_sequences,1);
        
        sub_descriptors = {};
        for j=1:nSeqs
            j_sequence = sub_sequences{j};
            descriptor = descriptorHOG1D(j_sequence,cutoff, param_hog1d);
            sub_descriptors = [sub_descriptors; descriptor];
        end        
        descriptors{i} = sub_descriptors;
    end
    
    hog1d_ms = descriptors;
 
end