
function DTWMDSfileName =  validateDTWMDSSymbolFileName(DTWMDSfileName, K)
    if nargin ==1
        K = 20;
        DTWMDSfileName = sprintf('%s-K-%d-symbols.mat', DTWMDSfileName(1:end-4), K);
    elseif nargin == 2 && isempty(K)
        K = 20;
        DTWMDSfileName = sprintf('%s-K-%d-symbols.mat', DTWMDSfileName(1:end-4), K);
	elseif nargin == 2 && ~isempty(K)
        DTWMDSfileName = sprintf('%s-K-%d-symbols.mat', DTWMDSfileName(1:end-4), K);
    else
        error('Incorrect input parameters\n');
    end
end