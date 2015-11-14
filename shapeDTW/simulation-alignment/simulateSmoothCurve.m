
function curve = simulateSmoothCurve(param)
% simulate a smooth curve
% inputs:
%       n_pt   -- # of temporal points
%       max_dt -- max 1st order derivative
%       nNest  -- control the smoothness of the simulated curve
%                 the larger, the smoother

% simulate brownian motion
    
    if nargin == 0
        param = validateSmoothCurveParam;        
    end
    param = validateSmoothCurveParam(param);

    len = param.len;
    max_dt = param.maxDerivative;
    nNest = param.nNest;

    dt = sin(randn(1, len)) * max_dt;
    cum_dt = cumsum(dt);
    for i=2:nNest
        cum_dt = cumsum(dt);
        if (max(cum_dt) - min(cum_dt) ) > 2*pi
            cum_dt = (cum_dt - min(cum_dt))/range(cum_dt)*(2*pi) + min(cum_dt);
        end
        dt = sin(cum_dt) * max_dt;
    end
    curve = cum_dt;

end