function  partitions = leaveOneOut(nTrain)
    
    partitions = diag(ones(1,nTrain));
     partitions = logical(partitions);
    
    
end