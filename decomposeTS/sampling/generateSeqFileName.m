% in order to standardize the sequence file name
function  seqsFileName = ...
                generateSeqFileName(sampling_method, seqlen, stride, sel)
    
    if nargin == 1
        seqlen = 52;
        stride = round((seqlen-2)/2);
        sel = 4;
    elseif nargin == 2
        stride = round((seqlen-2)/2);    
        sel = 4;
    elseif nargin == 2 && isempty(seqlen)
        seqlen = 52;
        stride = round((seqlen-2)/2);
        sel = 4;
    elseif nargin == 3 && isempty(stride) && ~isempty(seqlen)
        stride = round((seqlen-2)/2);
        sel = 4;
    elseif nargin == 3 && isempty(stride) && isempty(seqlen)
        seqlen = 52;
        stride = round((seqlen-2)/2);
        sel = 4;
    elseif nargin == 4 && isempty(sel)
        sel = 4;
    else
        sel =4;
    end
    
    switch sampling_method
        case 'evenly'                 
            seqsFileName = sprintf('sampled-subsequences-evenly-seqlen-%d-stride-%d', ...
                                        seqlen, stride);
        case 'featurePts'                 
            seqsFileName = sprintf('sampled-subsequences-atfeaturePts-sel-%d', ...
                                        sel);
        case 'hybrid'            
            seqsFileName = sprintf('sampled-subsequences-hybridPts-seqlen-%d-stride-%d-sel-%d', ...
                                        seqlen, stride, sel);
        case 'randomly'            
            seqsFileName = sprintf('sampled-subsequences-randomly-seqlen-%d-stride-%d', ...
                                        seqlen, stride);                                    
        otherwise
            error('Sampling Methods are confined to be: 1) evenly; 2) featurePts; 3) hybrid; 4) randomly\n');
    end
    
       
end