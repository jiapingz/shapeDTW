% interval features: mean, variance and slope
% scale parameter is used to scale time axis
% scale: very similar to scale used in HOG

% slope, mean and variance within each interval

function vec = BaydoganFeatures(sequence, scale)
    
    if nargin == 1
        scale = 1.0;
    elseif nargin == 2
    else 
        error('Please input 1 or 2 parameters\n');
    end
    
    if ~isvector(sequence)
        error('The input must be a vector\n');
    end
    
    me  =   mean(sequence);
    v   =   var(sequence);
    
    x = 1:length(sequence);
    x = scale * x;
    
    if length(sequence) == 1
        slope = 0;
    else
        p = polyfit(x(:), sequence(:),1);    
        slope = p(1);    
    end
    vec = [me, v, slope];
    
end