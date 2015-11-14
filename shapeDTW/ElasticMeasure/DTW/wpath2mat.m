
function wMat = wpath2mat(p)
    lenSignal = p(end);
    lenPath   = length(p);
    
    wMat = zeros(lenPath, lenSignal);

    for i=1:lenPath
        wMat(i, p(i)) = 1;
    end
    
    
end