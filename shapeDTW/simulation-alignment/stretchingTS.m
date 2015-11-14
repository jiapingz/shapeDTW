function [simulateIdx, match] = stretchingTS(len, param)
% stretching time series of length 'len'

    val_param   =   validateStretchingParam(param);
    percent     =   val_param.percentage;
    amount      =   val_param.amount;
    
    percent = min(1, percent);
    percent = max(0, percent);
    
    nPts = round(percent*len);
    
    rng('shuffle');
    rorder = randperm(len);
    
    idxPts = rorder(1:nPts);
    amounts = randi(amount+1,1,nPts);
    
    
    match = [];
    flag = zeros(1,len) > 1.0;
    stretches = zeros(1,len);
    stretches(idxPts) = amounts;
    flag(idxPts) = true;
    
    simulateIdx = [];
    cntLen = 0;
    for i=1:len
        if flag(i) == false
            cntLen              =  cntLen + 1;
            simulateIdx(cntLen) =  i;
            match = cat(1, match, [i cntLen]);
            continue;
        end
        
        for j=1:stretches(i)
           cntLen = cntLen + 1;
           simulateIdx(cntLen) = i;
           match = cat(1, match, [i cntLen]);            
        end        
    end
    
end