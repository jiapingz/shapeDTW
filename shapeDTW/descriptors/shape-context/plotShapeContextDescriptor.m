% plot shape context descriptor
function plotShapeContextDescriptor(scInfo)
    
    figure; 
    
    nrBins      =   scInfo.nrBins;
    nthetaBins  =   scInfo.nthetaBins;
    rBins       =   scInfo.rBins;
    thetaBins   =   scInfo.thetaBins;
    
    ts = scInfo.ts;
    sc = scInfo.sc;
    
%% (1) draw time series and log-polar coordinate
    x0 = 0;
    y0 = 0;
    h = axes('Position', [0.1 0.1 0.4 0.8]);

    for i=1:nrBins
        ellipse(rBins(i), rBins(i), 0, x0, y0, 'r'); hold on;
    end
    
    for i=1:nthetaBins
        
        ang = rem(rem(thetaBins(i),2*pi)+2*pi,2*pi);
        if ang <= 3/2*pi && ang > 1/2*pi
            s = -1;
        else
            s = 1;
        end
        
        x1 = s*sqrt( rBins(end)^2/(1+tan(thetaBins(i))^2));
        y1 = tan(thetaBins(i)) * x1;
        
        plot([0 x1], [0 y1], 'r'); hold on;
    end
    
    seqlen = size(ts,2);
    midIdx = ceil(seqlen/2);
    refPt = ts(:,midIdx);
    ts = ts - repmat(refPt, 1, seqlen);
    
    plot(ts(1,:), ts(2,:), '-bo', 'linewidth',2);
    axis equal; axis tight;
    
 %% (2) draw descriptor
    
    h = axes('Position', [0.55 0.1 0.4 0.8]);
	colormap(gray); 
    scImg = reshape(sc,nthetaBins,nrBins)';
    scImg = scImg/max(scImg(:));
    imagesc(scImg); axis equal; axis tight;
    set(gca,    'xtick',[], 'xticklabel', [], 'ytick',[] , 'yticklabel', [], 'XColor', [1 1 1], 'YColor', [1 1 1])  ;
    set(gca,  'xtick',[], 'xticklabel', [], 'XColor', [1 1 1])  ;
     
    
end