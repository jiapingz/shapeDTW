
function varargout = doClustering(X, clust_method, param)
    
    narginchk(3,3);    
    switch clust_method
        case 'kmeans'
            val_param = validateKMeansparam(param);
            nclusters = val_param.nclusters;
            emptyaction = val_param.EmptyAction;
            [partition,~] = ...
            kmeans(X, nclusters, 'emptyaction', emptyaction, 'replicates', 1);
        case 'selfTuning'
            val_param = validateSelfTuningparam(param);
            cluster_choices = val_param.nClusters;
            nNeighbors = val_param.nNeighbors;
            weights = val_param.weights;
            [partition, nclusters] = selfTuningPortal(X, cluster_choices, nNeighbors, weights);
        case 'ncut'
            val_param = validateNCutparam(param);
            nclusters = val_param.nclusters;
            sigma = val_param.sigma;            
            partition = ncutPortal(X,nclusters,sigma);
        case 'graclus'
            val_param = validateGraclusparam(param);
            nclusters = val_param.nclusters;
            cutType = val_param.cutType;
            sigma = val_param.sigma;
            partition = graclusPortal(X, nclusters, cutType, sigma);
        otherwise
            error('Only support ''kmeans'' ''selfTuning'' ''graclus'' ''ncut'' clustering methods\n');
    end
    
    varargout = {partition, nclusters};

    
end