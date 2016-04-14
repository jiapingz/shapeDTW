
function val_setting = validateSamplingSetting(setting)
    if nargin == 0
        val_setting = struct('method', 'hybrid', ...
                             'param', struct('sel', 5, ...
                                             'seqlen', 52, ...
                                             'stride', 25));
        return;
    end
    
    val_setting = setting;
    if ~isfield(setting, 'method')
        val_setting.method = 'hybrid';
    end
    
    if ~isfield(setting, 'param')
        val_setting.param = struct('sel', 5, ...
                                   'seqlen', 52, ...
                                   'stride', 25);
    end

end