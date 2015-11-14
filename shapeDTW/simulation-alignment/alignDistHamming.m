function d = alignDistHamming(align1, align2)
% compute hamming distance between two alignments
% inputs:
%         align1 -- alignment one, nx2
%         align2 -- alignment two, mx2

% ouputs:
%         d -- hamming distance between align1 and align2
   
% make sure the alignemnt path is increasing
    p1 = align1(:,1);
    q1 = align1(:,2);
    [p1, idx] = sort(p1);
    q1 = q1(idx);
    
    len_p_1 = p1(end);
    len_q_1 = q1(end);
        
% make sure the alignemnt path is increasing
    p2 = align2(:,1);
    q2 = align2(:,2);
    [p2, idx] = sort(p2);
    q2 = q2(idx);
       
    len_p_2 = p2(end);
    len_q_2 = q2(end);
        
    if len_p_1 ~= len_p_2
        tmp = p2;
        p2 = q2;
        q2 = tmp;
        len_p_2 = len_p_1;
        len_q_2 = len_q_1;
    end
    
    if p1(end) ~= p2(end) || q1(end) ~= q2(end)
        error('Make sure two alignments are between the same pair of time series\n');
    end
    
    len_p = len_p_1;
    len_q = len_q_1;
    
    loss = 0;
    for i=1:len_p
        idx_q1 = q1(p1 == i);
        idx_q2 = q2(p2 == i);
        tmp = numel(unique([idx_q1; idx_q2]));
        if tmp ~= 1
            loss = loss + tmp;
        end
    end

    d = loss;
end