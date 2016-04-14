
% only support ascending or descending sequences
function n = whichInterval(sequence, number)
    len = length(sequence);
    
    if sequence(1) > sequence(2)
        increasing = false;
    else
        increasing = true;
    end
    
    switch increasing
        case true
            for i=1:len-1
                if sequence(i) <= number && sequence(i+1) > number
                    n = i;
                    return;
                elseif sequence(1) > number
                        n = 1;
                        return;
                 elseif sequence(len) < number
                        n = len-1;
                        return;                 
                end
            end                
            
        case false
            for i=1:len-1
                if sequence(i) >= number && sequence(i+1) < number
                    n = i;
                    return;
                elseif sequence(1) < number
                    n = 1;
                    return;
                elseif sequence(len) > number
                    n = len-1;
                    return;
                end
                
            end
    end
 
end