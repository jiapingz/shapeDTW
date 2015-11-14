% sample sequence from designated points
% given:  the sequence of feature points,
% return: subsequences
function [sequences, tAnchor] = samplingSequencesIdx(sensordata, seqlen, idx)
    narginchk(3,3);
    [nTimeStamps, nDims] = size(sensordata);
    if nTimeStamps < nDims
        warning('Synchronized signals should be arranged column-wisely\n');
    end
%     if size(sensordata,1) <= seqlen
%         sequences{1} = sensordata;
%         tAnchor = 1;
%         return;
%     end
    

    nTimeStamps = size(sensordata,1);
    mask = 1:seqlen;
    mask = mask - ceil(seqlen/2);
    
    nSeqs = length(idx);
    sequences = {};
    tAnchor = idx;
    cnt = 0;
    for i=1:nSeqs
        iloc = idx(i);
        imask = mask + iloc;
%         if imask(1) <= 0 || imask(end) > nTimeStamps
%             continue;
%         end 
        
        if imask(1) <= 0 && imask(end) <= nTimeStamps
            tmp = repmat(sensordata(1,:), 1-imask(1),1);
            isequence = [tmp; sensordata(1:imask(end),:)];
        elseif imask(end) > nTimeStamps && imask(1) >= 1
            tmp = repmat(sensordata(end,:), imask(end) - nTimeStamps,1);
            isequence = [sensordata(imask(1):nTimeStamps,:); tmp];
        elseif imask(1) <= 0 && imask(end) > nTimeStamps
            tmp1 = repmat(sensordata(1,:), 1-imask(1),1);
            tmp2 = repmat(sensordata(end,:), imask(end) - nTimeStamps,1);
            isequence = [tmp1; sensordata; tmp2];            
        else
            isequence = sensordata(imask,:);
        end
        
        cnt = cnt + 1;
        tAnchor(cnt) = iloc;
%         isequence = sensordata(imask,:);        
        sequences = cat(1,sequences,isequence);
    end
    tAnchor = tAnchor(1:cnt);
  
end

