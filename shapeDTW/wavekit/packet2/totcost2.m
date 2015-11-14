function [m, c] = totcost2(w)

% TOTCOST2 -- computes costs for all subspaces
% 
% [marks, costs] = totcost2(w)
%
% Subroutine of bestbas2.
%
% See also BESTBAS2.

% (C) 1997 Harri Ojanen

N = size(w.wp,1);
levels = size(w.wp,3);
c = cell(levels,1);
for l = 1 : levels-1
    [i,j] = meshgrid(wp2blks(N,l+1));	
    c{l} = sparse(i,j,zeros(size(i)),N,N);
end
m = c;


%dots('totcost2', levels);

c{levels} = costfn(w.wp(:,:,levels), 1);
%dots

for level = levels-1 : -1 : 1

    costs = costfn(w.wp(:, :, level), 1);
    
    blks = wp2blks(N, level+1);
    for i = blks
        for j = blks

            delta = N / 2^level; d2 = delta/2;
            %C = costfn(w.wp(i : i+delta-1, j : j+delta-1, level));
            C = sum(sum(costs(i : i+delta-1, j : j+delta-1)));
            c{level}(i,j) = C;
            %chlcost = c{level+1}(i,         j) + ...
            %          c{level+1}(i+delta/2, j) + ...
            %          c{level+1}(i,         j+delta/2) + ...
            %          c{level+1}(i+delta/2, j+delta/2);
            %chlcost = sum(sum(c{level+1}(i:d2:i+d2, j:d2:j+d2)));
            chlcost = sum(sum(c{level+1}(i:i+d2, j:j+d2)));
            if C > chlcost
                c{level}(i,j) = chlcost;
            else
                m{level}(i,j) = 1;
            end  

        end
    end
    %dots
end

%dots(-1)
