function scInfo =  validateShapeContextInfo(info)

    narginchk(0,1);
    
    if nargin == 0
        scInfo = struct('ts', [], ...
                        'sc', [], ...
                        'nrBins', 5, ...
                        'nthetaBins', 12, ...
                        'rBins', [], ...
                        'thetaBins', []);
        return;
    end

    scInfo = info;
    if ~isfield(scInfo, 'ts')
        scInfo.ts  = [];
    end
    
    if ~isfield(scInfo, 'sc')
        scInfo.sc = [];
    end
    
    if ~isfield(scInfo, 'nrBins')
        scInfo.nrBins = 5;
    end
    
    if ~isfield(scInfo, 'nthetaBins')
        scInfo.nthetaBins = 12;
    end
    
    if ~isfield(scInfo, 'rBins')
        scInfo.rBins = [];
    end
    
    if ~isfield(scInfo, 'thetaBins')
        scInfo.thetaBins = [];
    end
        

%    scInfo.sc         = BH;
%    scInfo.ts         = subsequence;
%    scInfo.nrBins     = nrBins;
%    scInfo.rBins      = r_bin_edges;
%    scInfo.nthetaBins = nthetaBins;
%    scInfo.thetaBins  = linspace(0, 2*pi, nthetaBins);

end