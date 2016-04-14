% rank shapelet in terms of this DTW distance in a greedy way
% greedy algorithm
% satisfy as many distance constraints as possible
% borrow idea from relative attribute
function [ranked_shapelets, idx] = relativeShapelets(shapelets)
    % DTW distances without window constraints
%     distDTW = dtw_2sets(shapelets);
    cnt = 0;
    for i=1:numel(shapelets)
        rShapelet = shapelets{i};        
        for j=i+1:numel(shapelets)
            tShapelet = shapelets{j};
            cnt = cnt + 1;
            distDTW(cnt) = dtw_c(rShapelet(:), tShapelet(:));
        end
    end
	distDTW = squareform(distDTW);
    
    ranked_shapelets = {};
    idx = [];
    nShapelets = numel(shapelets);
    
    for i=1:nShapelets
        if i == 1 || i == 2
            ranked_shapelets = cat(1,ranked_shapelets,shapelets{i});
            idx = cat(1, idx, i);
        else
            i_ranked_shapelets = cell(i,i);
            i_idx = zeros(i,i);
            cnt = zeros(i,1);
            gaps = zeros(i,1);
            for k=1:i              
                i_ranked_shapelets{k,k} = shapelets{i};
                i_idx(k,k) = i;
                if k >= 2
                    i_ranked_shapelets(1:k-1,k) = ranked_shapelets(1:k-1);
                    i_idx(1:k-1,k) = idx(1:k-1);
                end
                if k <= i-1
                    i_ranked_shapelets(k+1:i,k) = ranked_shapelets(k:i-1);
                    i_idx(k+1:i,k) = idx(k:i-1);
                end                
                [cnt(k), gaps(k)] = nConsistencyShapelets(i_ranked_shapelets(:,k), i_idx(:,k), distDTW);                
            end
            % break the tie
            % first by maximize the number of satisfying constraints
            % then by minimize the max gap
            [tMax, ~] = max(cnt);
            tIdx = find(cnt == tMax);
%             tIdx = tIdx(1);
            if numel(tIdx) ~= 1
                gaps = gaps(tIdx);
                [~, ttIdx] = min(gaps);
                tIdx = tIdx(ttIdx);
            end
            ranked_shapelets = i_ranked_shapelets(:,tIdx);
            idx = i_idx(:,tIdx);            
        end
    end

end

function [num, nonGap] = nSatisfyIncreasing(val)
    flag = zeros(1,numel(val)-1) < -1;
    nonGap = 0;
    for i=1:numel(val)-1
        flag(i) = val(i) <= val(i+1);
        if flag(i) == false
            nonGap = max([nonGap abs(val(i)-val(i+1))]);
         end
    end   
    num = sum(flag);
end

function [num, nonGap] = nConsistencyShapelets(shapelets, idx, distDTW)

    nShapelets = numel(shapelets);
    cntConsistency = 0;
    nonGap = 0;
    for i=1:nShapelets
        rIdx = idx(i);
        i_cntConsistency = 0;
        % left  
        if i > 2
            vals = zeros(i-1,1);
            for j=i-1:-1:1
                tIdx = idx(j);
                vals(i-j) = distDTW(rIdx, tIdx);
            end
            [tmp_cnt, gap] = nSatisfyIncreasing(vals);
            i_cntConsistency = i_cntConsistency + tmp_cnt;
            nonGap = max([gap nonGap]);
        end        
        % right
        if i < nShapelets - 1
            vals = zeros(nShapelets-i,1);
            for j=i+1:nShapelets
                tIdx = idx(j);
                vals(j-i) = distDTW(rIdx, tIdx);
            end
            [tmp_cnt, gap] = nSatisfyIncreasing(vals);
            i_cntConsistency = i_cntConsistency + tmp_cnt;
            nonGap = max([gap nonGap]);
        end         
        cntConsistency = cntConsistency + i_cntConsistency;
    end     
    num = cntConsistency;
    return;    
end



