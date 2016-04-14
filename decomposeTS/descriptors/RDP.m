% iterative end-point fit algorithm

% for an ordinary iterative end-point fit algorithm, tol is defined to end
% the splitting, however, in this case, the number of maximal segments is
% used to terminate the algrithm whenever the maximal number of segments is
% reached.
function [sp, idx, nSeg] = RDP(p, nSeg)
    
    error(nargchk(2,2,nargin));
    p = p(:);
    nPts = size(p,1);
    segment = struct('idxs', 1, ...
                     'idxe', nPts, ...
                     'maxdeviation',[]);
    
    segment = RDP_deviation(p, segment);
    segments{1} = segment;
    
    bflag = true;
    while bflag && numel(segments) < nSeg
        [segments, bflag] = RDP_split(p, segments);
    end
    
    nSeg = numel(segments);
    idx = [];
    for i=1:nSeg
        idx = cat(1, idx, segments{i}.idxs);
        idx = cat(1, idx, segments{i}.idxe);
    end
    
    idx = unique(idx);
    idx = sort(idx, 'ascend');
    
    sp = p(idx,:);
    nSeg = size(sp,1)-1;
    
end


function [segments, bflag] = RDP_split(p, segments)
    
    nSeg = numel(segments);
    
    deviations = zeros(nSeg,1);
    for i=1:nSeg
        deviations(i) = segments{i}.maxdeviation;
    end
    
    [~,idx] = max(deviations);
    segment = segments{idx};
    idxs = segment.idxs;
    idxe = segment.idxe;
    if idxe == idxs +1
        bflag = false;
        return;
    end
    segments = segments(1:nSeg ~= idx);
    nSeg = nSeg - 1;
    
    if size(p,2) == 1
        xs = 1:(idxe - idxs +1);
        ys = p(idxs:idxe);
        pts = [xs' ys];        
    else
        pts = p(idxs:idxe,:);
    end
    curve = [pts(1,:); pts(end,:)];
    
    [~,distance,~] = distance2curve(curve,pts);
    
    [~,idx] = max(distance);
    if idx == 1
        idx = 2;
    elseif idx == length(distance)
        idx = length(distance)-1;
    end
    
    seg1 = struct('idxs', idxs, ...
                  'idxe', idxs+idx-1, ...
                  'maxdeviation', 0);
              
    seg2 = struct('idxs', idxs+idx-1, ...
                  'idxe', idxe, ...
                  'maxdeviation', 0);
              
    % get the deviation values of segment1 and segment2
    seg1 = RDP_deviation(p, seg1);
    seg2 = RDP_deviation(p, seg2);
    segments{nSeg+1} = seg1;
    segments{nSeg+2} = seg2;
    bflag = true;
    
    
end

function segment = RDP_deviation(p, segment)
    idxs = segment.idxs;
    idxe = segment.idxe;
    if size(p,2) == 1
        xs = 1:(idxe - idxs +1);
        ys = p(idxs:idxe);
        pts = [xs' ys];        
    else
        pts = p(idxs:idxe,:);
    end
    curve = [pts(1,:); pts(end,:)];
    
    [~,distance,~] = distance2curve(curve,pts);
    segment.maxdeviation = max(distance);
end

