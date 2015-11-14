% motion intensity

function mi = motionIntensity(at)
    if ~isvector(at) 
        error('inputs needs to be a vector\n');
    end
    mi = sqrt(sum(at.^2));
end