% compute Normalized Signal Magnitude 

function normSM = NSM(seq)
    if ~ismatrix(seq) %%  && size(seq,2) ~= 3
        error('Input needs to be a 2D matrix with each row be observation of time t\n');
    end
    
    normSM = sum(sum(abs(seq)))/size(seq,1);
    
end