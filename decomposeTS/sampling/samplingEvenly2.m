% when doing evenly sampling, we choose a random start point, specifically
% randomStartPt = randi(stride);

% this function is specifically designed for 5s activity recognition

function [accel_subsequences, gyro_subsequences, subsequenceIdx] = ...
                    samplingEvenly2(accel, gyro, seqlen, stride)

    if ~ismatrix(accel) && ~isvector(accel)
        error('The 1st input parameter must be of matrix type\n');
    end

    %{
    if numel(sensordata) ~= max(size(sensordata))
        error('The 1st input should be 1-D time series\n');
    end    
    sensordata = sensordata(:);
    %}
    
    accel_subsequences = {}; 
    gyro_subsequences = {};
    subsequenceIdx = [];
    len = size(accel,1);
    rng('shuffle');
    tstart = randi(stride);
    tend = tstart + seqlen - 1;
    
%     while tstart >=1 && tstart <= len && ...
%             tend >=1 && tend <= len
%         subsequences = cat(1, subsequences, sensordata(tstart:tend,:));
%         subsequenceIdx = cat(1,subsequenceIdx, round((tend-tstart+1)/2));
%         tstart = tstart + stride;
%         tend = tend + stride;
%     end
    
    while 1
        if tstart > len
            break;
        end
        
        if tstart <= len && tend <= len
            accel_subsequences = cat(1, accel_subsequences, accel(tstart:tend,:));
            gyro_subsequences = cat(1, gyro_subsequences, gyro(tstart:tend,:));

            subsequenceIdx = cat(1,subsequenceIdx, round((tend-tstart+1)/2));
            tstart = tstart + stride;
            tend = tend + stride;
            continue;
        end
        
        if tstart <= len && tend > len
            tend = len;
            if (tend - tstart) < seqlen/2
                break;
            end
            
            accel_subsequences = cat(1, accel_subsequences, accel(tstart:tend,:));
            gyro_subsequences = cat(1, gyro_subsequences, gyro(tstart:tend,:));
            subsequenceIdx = cat(1,subsequenceIdx, round((tend-tstart+1)/2));
            tstart = tstart + stride;
            tend = tend + stride;
            break;
            
        end        
        
    end
    
    
end