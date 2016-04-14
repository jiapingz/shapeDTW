% mean of motion intensity

function meMI =  meanMotionIntensity(seq)
    if ~ismatrix(seq)  % && size(seq,2) ~= 3
        error('Input needs to be a 2D matrix with each row be observation of time t\n');
    end
    
    meMI = mean(sqrt(sum(seq.^2, 2)));
    
end