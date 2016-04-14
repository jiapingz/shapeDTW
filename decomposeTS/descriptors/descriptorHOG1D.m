% inspired by great performance of HOG descriptor on 2D images and HOG3D
% descriptors on 3D videos, we introduce HOG1D into time series

% with l2 normalization

function  [descriptor, subdescriptors]  = descriptorHOG1D(sequence, param)

    if nargin <= 1
%         param.blocks        = [1 2];    % unit: cell
        param.cells         = [1 25];   % unit: t
        param.overlap       = 12;
        param.gradmethod    = 'centered'; % 'centered'
        param.nbins         = 8;
        param.sign          = 'true';
%         param.cutoff        = [2 51];
        param.xscale         = 0.1;
    end
    
    if nargin < 1
        error('Not enough inputs\n');
    end
    
    % in this function, instead of considering zero padding, the input
    % 'sequence' is usually longer than the target sequence, therefore,
    % additional parameter 'cutoff' is necessary to specify the front and
    % end 'cutoff' locations of the target sequnce in terms of the
    % reference sequence
    
    val_param   = validateHOG1Dparam(param); 
    cells       = val_param.cells;
    gradmethod  = val_param.gradmethod;
    nbins       = val_param.nbins;
    dx_scale    = val_param.xscale;
%     cutoff      = val_param.cutoff;
    sequence = sequence(:);
    seqlen = length(sequence);
    

    
    sCell   = cells(2);
    overlap = val_param.overlap;
    
    % the direction of gradients range from -pi/2 to pi/2
    switch val_param.sign
        case 'false'
            angles = linspace(0, pi/2, nbins+1);
        otherwise
            angles = linspace(-pi/2, pi/2, nbins+1);            
    end
    
    centerAngles = zeros(1, nbins);
    for i=1:nbins
        centerAngles(i) = (angles(i) + angles(i+1))/2;
    end
    
     
    %{
    if floor(len_target/sCell) ~= sBlock
        error('Inconsistency among input parameters\n');
    end
    %}
    % now we only suport maximal number of 10 blocks
    ref_lens = zeros(10,1);
    for i=1:10
        ref_lens(i) = sCell*i - overlap*(i-1);
    end
    [~, idx] = min(abs(ref_lens - length(sequence)));
    if (length(sequence) - ref_lens(idx)) > 0 && ...
            (length(sequence) - ref_lens(idx)) < 2
          sequence = [sequence(1); sequence; sequence(end)];
    elseif (length(sequence) - ref_lens(idx)) <= 0
        margin = ref_lens(idx) - length(sequence) + 2;
        leftMargin = round(margin/2);
        rightMargin = margin - leftMargin;
        sequence = [sequence(1)*ones(leftMargin,1); ...
                sequence; sequence(end)*ones(rightMargin,1)];
    end
    
    nBlock = idx;

    
% 	if (sCell * nBlock - overlap*(nBlock-1)) <= len_target
%         error('Inconsistency among input parameters found\n');
%     end
    
%     nBlock = sBlock;
	descriptor = zeros(nBlock, nbins); 
    idx_start = 1;
    
    for i=1:nBlock
        for j=1:sCell
            idx = i*sCell - (i-1)*overlap - sCell  + j;
            cidx = idx_start + idx - 1;
            
            switch gradmethod
                case 'uncentered'
                    sidx = cidx;
                    eidx = cidx + 1;
                    if sidx < 1 || eidx > seqlen
                        continue;
                    end
                    
                    dx = 1*dx_scale;
                    dy = sequence(eidx) - sequence(sidx);
                    ang = atan2(dy,dx);
                    mag = dy/dx;
                    
                case 'centered'
                    sidx = cidx - 1;
                    eidx = cidx + 1;
                    if sidx < 1 || eidx > seqlen
                        continue;
                    end
                    dx = 2*dx_scale;
                    dy = sequence(eidx) - sequence(sidx);
                    ang = atan2(dy,dx);
                    mag = dy/dx;
            end
            
            switch val_param.sign
                case 'false'
                    error('Now param.sign can only be true\n');                    
                case 'true'
                    n = whichInterval(angles, ang);
                    if n == 1 && ang <= centerAngles(1)
                        descriptor(i,n) = descriptor(i,n) + abs(mag);
                    elseif n == nbins && ang > centerAngles(nbins)
                        descriptor(i,n) = descriptor(i,n) + abs(mag);
                    else
                        if abs(angles(n) - ang) > ...
                                        abs(angles(n+1) - ang)
                            ang1 = centerAngles(n); 
                            ang2 = centerAngles(n+1);
                            
                            descriptor(i,n) = descriptor(i,n) + ...
                                           abs(mag) * cos(ang1-ang);
                            descriptor(i,n+1) = descriptor(i,n+1) + ...
                                                abs(mag) * cos(ang2-ang);
                        else
                            ang1 = centerAngles(n-1);
                            ang2 = centerAngles(n);

                            descriptor(i,n-1) = descriptor(i,n-1) + ...
                                           abs(mag) * cos(ang1-ang);
                            descriptor(i,n) = descriptor(i,n) + ...
                                                abs(mag) * cos(ang2-ang);                            
                        end                        

                    end                    
            end
        end
    end
    
    % l2 normalization
%     epsilon = 1.0e-6;
%     descriptor = descriptor ./ (repmat(sqrt(sum(descriptor.^2,2)),1,nbins) + epsilon);
    
    subdescriptors = descriptor;
    descriptor = reshape(descriptor',1,nBlock*nbins);
    
%         epsilon = 1.0e-6;
%     descriptor = descriptor/(sqrt(sum(descriptor.*descriptor))+epsilon);
    
end
