% this a bug to fix:
% histograms in different blocks should not be normalized !!!
% in such way, different shapes will have different HOGs

function plotHOG1D(sequence, param)
    val_param = validateHOG1Dparam(param);  
%     val_param.xscale = 1.5;
    [descriptor, subdescriptors] = descriptorHOG1D(sequence, val_param);
    
	cells       = val_param.cells;    
    nbins       = val_param.nbins;
    sCell   = cells(2);
    overlap = val_param.overlap;

    nSubdescriptors = size(subdescriptors,1);
    boxX = [];
    boxY = [];
    boxW = [];
    boxH = [];
    
    seqlen = length(sequence);
    
    for i=1:nSubdescriptors
        xStart = (sCell - overlap)*(i-1)+1;
        xLen = sCell;
        xEnd = min(xStart+xLen-1, seqlen);
        
        yStart = min(sequence(xStart:xEnd));
        yLen = max(sequence(xStart:xEnd)) - yStart;
        
%         boxX = cat(2, boxX, xStart-0.2 );
%         boxY = cat(2, boxY, yStart-0.2);
%         
%         boxW = cat(2, boxW, xLen-0.5);
%         boxH = cat(2, boxH, yLen+0.5);

        boxX = cat(2, boxX, xStart);
        boxY = cat(2, boxY, yStart);
        
        boxW = cat(2, boxW, xLen);
        boxH = cat(2, boxH, yLen);

    end
    
    
    
    
    
    x = 1:length(sequence);
    x = x(:);
    y = sequence(:);
    
    len = length(sequence);
    u = [];
    v = [];
    xPt = [];
    yPt = [];
    skip = 1;
    
    for i=1:skip:len
        
        switch val_param.gradmethod
            case 'uncentered'
                cidx = i;
                sidx = cidx;
                eidx = cidx + 1;
                if sidx < 1 || eidx > len
                    continue;
                end
                dy = y(eidx) - y(sidx);
                dx = x(eidx) - x(sidx);
                xPt = cat(1, xPt, x(cidx));
                yPt = cat(1, yPt, y(cidx));
                u = cat(1, u, dx);
                v = cat(1, v, dy);


            case 'centered'
                cidx = i;
                sidx = cidx - 1;
                eidx = cidx + 1;
                if sidx < 1 || eidx > len
                    continue;
                end

                dy = y(eidx) - y(sidx);
                dx = x(eidx) - x(sidx);
                xPt = cat(1, xPt, x(cidx));
                yPt = cat(1, yPt, y(cidx));
                u = cat(1, u, 0.5*dx);
                v = cat(1, v, 0.5*dy);
                
        end
    end
    scopeSeq = max(sequence(:)) - min(sequence(:));
    minY = min(sequence(:)) - 0.2*scopeSeq;
    maxY = max(sequence(:)) +  0.2*scopeSeq;
    minX = - 0.2*scopeSeq;
    maxX = length(sequence) +  0.2*scopeSeq;
    
    xText = (minX+maxX)/2;
    yText = maxY ;
    
    
    figure; 
    set(gcf, 'position', [400 400 1200 500]);
    set(gca, 'Position', [0 0 1 1]);    
	h = axes('Position',[0,0.3,1.0,0.7]);
    % plot gradients 
    
    plot(x,y, 'g', 'LineWidth',4); hold on;
    plot(x,y, 'ro', 'MarkerSize',8,...
    'MarkerEdgeColor','k', 'LineWidth', 2); hold on;
    
    nPts = length(xPt);
    
    for i=1:nPts
        quiver(xPt(i), yPt(i), u(i), v(i), 'b', 'LineWidth', 2, 'MaxHeadSize', 5);
        hold on;
        
    end
    
    % plot boxes    
%     colors = {'m', 'r', 'c', 'b'};
    colors = cell(1,5);
    for i=1:5
        colors{i} = [rand rand rand];
    end


    xCenters = [];
    yBases = [];
    subdescriptors = subdescriptors./(max(subdescriptors(:)) - min(subdescriptors(:)))...
                                *(max(sequence(:)) - min(sequence(:)));
    minSeq = min(sequence(:));
%     scopeSeq = max(sequence(:)) - min(sequence(:));
    for i=1:nSubdescriptors
       rectangle('Position', [boxX(i), boxY(i), boxW(i), boxH(i)], 'Curvature',0.2,'LineStyle', '--', 'EdgeColor', colors{i}, 'LineWidth',3);
       hold on;
       xCenters = cat(2, xCenters, boxX(i) + boxW(i)/2);
       yBases = cat(2, yBases, minSeq - 1.2*scopeSeq);
    end
%     set(h,    'xtick',[],'ytick',[] , 'XColor', [1 1 1], 'YColor', [0 0 0 ])  ;
%     rectangle('Position',[minX, minY, (maxX-minX), (maxY-minY)], 'EdgeColor', [0 0 0]);
%     plot([minX maxX], [minY minY], 'color', [1 1 1 ]); hold on;
%     plot([minX maxX], [maxY   maxY ], 'color', [1 1 1 ]);
    set(gca,    'xtick',[],'ytick',[] , 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
%     text(xText, yText, 'HOG-1D', 'FontSize', 20);
%     title('HOG-1D', 'FontSize', 20);
    axis tight;


%     axis off;

    
    % plot bar
    for i=1:nSubdescriptors
        tmpHist = subdescriptors(i,:);
        x = 1:nbins;
        x = x/nbins*sCell*0.5;
        x = x - median(x(:)) + xCenters(i);
        y = tmpHist+ yBases(i);
        h = axes('Position',[(i-1)*1.0/nSubdescriptors,0.0,1.0/nSubdescriptors,0.3]);
        bar(tmpHist,0.8, 'EdgeColor', colors{i}, 'FaceColor', colors{i}); 
        set(h,    'xtick',[],'ytick',[] , 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
        axis tight;
        hold on;
%         axis off;
    end
    
    
    

 
    
end