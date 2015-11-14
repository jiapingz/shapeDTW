function val_param =  validateShapeContextparam(param)
    
    narginchk(0,1);
    
    if nargin == 0
        val_param = struct('xscale', 0.1, ...   % scaling of x coordinates
                            'nrBins', 5, ...    % bin number in Radius
                            'nthetaBins', 12, ... % bin number in Theta
                            'rmin', 0.15, ...   % min radius
                            'rmax', 2.23, ...   % max radius
                            'tanTheta', 0, ... % tangent in radian
                            'isRotateInv', 0);  % whether use rotation invariance    
        return;                                 % property or not            
    end
    
    val_param = param;
    if ~isfield(val_param, 'xscale')
        val_param.xscale = 0.1;
    end
    
    if ~isfield(val_param, 'nrBins')
        val_param.nrBins = 5;
    end
    
    if ~isfield(val_param, 'nthetaBins')
        val_param.nthetaBins = 12;
    end
    
    if ~isfield(val_param, 'rmin')
        val_param.rmin = 0.05;
    end
    
    if ~isfield(val_param, 'rmax')
        val_param.rmax = 2.23;
    end
    
    if ~isfield(val_param, 'tanTheta')
        val_param.tanTheta = 0;
    end
    
    
end