% plot confusion matrix
function plotCM(labelTest, predict_label, activityNames)

    [slabelTest, idx] = sort(labelTest, 'ascend');
    spredict_label = predict_label(idx);
    uniqueLabels = unique(labelTest);
    labelNames = activityNames(uniqueLabels);
    
    if length(uniqueLabels) ~= size(activityNames,1)
        error('Caution: # of classes in test and training doesnt match\n');
    end

    num_in_class = zeros(length(unique(slabelTest)),1);
    for i=1:length(unique(slabelTest))
        num_in_class(i) = sum(slabelTest == uniqueLabels(i));
    end
    [confusion_matrix]=compute_confusion_matrix(spredict_label,num_in_class,labelNames);    

end