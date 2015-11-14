% compute correlation coefficients of accelerations

function corrcoefs = corrcoefSeq(seq)
    if ~ismatrix(seq) % && size(seq,2) ~= 3
        error('Input needs to be a 2D matrix with each row be observation\n');
    end
    corrcoefs = corrcoef(seq);
end