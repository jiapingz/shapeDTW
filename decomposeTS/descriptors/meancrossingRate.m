% zero crossing rate

function mcRate = meancrossingRate(seq)
    me = mean(seq);
    nIntervals = length(seq) - 1;
    cnt = 0;
    for i=1:nIntervals
        if seq(i) < me && seq(i+1) > me
            cnt = cnt + 1;
        end
    end
    mcRate = cnt/nIntervals;
end