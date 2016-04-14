% validate hog1d parameter settings

function val_param = validateHOG1Dparam(param)

% a typical valid setting
    %{
        param.blocks    = [1 2];  % unit: cell
        param.cells     = [1 25]; % unit: t
        param.gradmethod = 'centered'; % 'centered'
        param.nbins = 8;
        param.sign = 'true';
	%}
    if nargin == 0 || ~isstruct(param) 
%         val_param.blocks    = [1 2];  % unit: cell
        val_param.cells     = [1 25]; %[1 25]; % unit: t
        val_param.overlap   = 0;
        val_param.gradmethod = 'centered'; % 'centered'
        val_param.nbins = 8;
        val_param.sign = 'true';
        val_param.xscale = 0.1;
%         val_param.cutoff = [2 51];
        val_param.sign = 'true';
        return;
    end

   
    if ~isfield(param, 'overlap')
        val_param.overlap = 12;
    else
        val_param.overlap = param.overlap;
    end
    
    if ~isfield(param, 'xscale')
        val_param.xscale = 0.1;
    else
        val_param.xscale = param.xscale;
    end
       
    if ~isfield(param, 'cells')
        val_param.cells = [1 25];
    else
        val_param.cells = param.cells;
    end
    
    if ~isfield(param, 'gradmethod')
        val_param.gradmethod = 'uncentered';
    else
        val_param.gradmethod = param.gradmethod;
    end
    
    if ~isfield(param, 'nbins')
        val_param.nbins = 8;
    else
        val_param.nbins = param.nbins;
    end
    
    if ~isfield(param, 'sign')
        val_param.sign = 'true';
    else
        val_param.sign = param.sign;
    end
end