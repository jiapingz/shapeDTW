function val_clustSetting = validateClusteringSetting(clustSetting)
    
    if nargin == 0
        kmeansSetting = validateKMeansparam;
        val_clustSetting = struct('method', 'kmeans', ... % 'selfTuning', 'ncut', 'graclus'
                                            'param', kmeansSetting);
         return;
    end
    
    val_clustSetting = clustSetting;
    if ~isfield(val_clustSetting, 'method')
        val_clustSetting.method  = 'kmeans';        
    end
    
    if ~isfield(val_clustSetting, 'param')
        switch val_clustSetting.method
            case 'kmeans'
                val_clustSetting.param = validateKMeansparam;
            case 'selfTuning'
                val_clustSetting.param = validateSelfTuningparam;
            case 'ncut'
                val_clustSetting.param = validateNCutparam;
            case 'graclus'
                val_clustSetting.param = validateGraclusparam;
            otherwise
                error('only support 4 clustering methods\n');                
        end               
    end
    
end