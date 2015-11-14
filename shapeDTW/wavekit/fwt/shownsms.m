function ymaxx = shownsms(msa,indices)

% SHOWNSMS -- show information on different levels of a multiscale analysis
%              (non standard version)
%
% maxlevels = shownsms(msa,indices)
%
% msa is from fwt1ns; it's length must be 2^n-2.
%
% indices (optional) if 1, display the indices of the coefficients
%
% See also SHOWMSA, SHOWOPER.

% (C) 1993-1997 Harri Ojanen

if nargin < 2, indices = 0; end
 

% Number of msa-levels
N = 2*lastnslv(msa);


% Maximum absolute values at different levels
ymax = zeros(N,1);
for k=0:N+1,
    if rem(k,2) == 0,
        ymax(k+1) = max(abs(nsmsalvl(msa,floor(k/2),0)));   % detail
    else
        ymax(k+1) = max(abs(nsmsalvl(msa,floor(k/2),1)));   % smooth
    end
end


% Scale maximum values
if max(ymax) > 0,
    scaleymax = ymax/max(ymax)*1.5;
else
    scaleymax = ymax;
end;


% Set axis and vertical ruler
clf
axis([-0.3 1 0 2*N+4])
axis('off')
hold on

if strcmp(get(gca,'color'), 'none')
    bgcolor = get(gcf,'color');
else
    bgcolor = get(gca,'color');
end


for k=0:N+1
    
    if rem(k,2) == 0,
        y = abs(nsmsalvl(msa,floor(k/2),0));   % detail
        l = nsmsaidx(floor(k/2), 0);
        color = 'r';
    else
        y = abs(nsmsalvl(msa,floor(k/2),1));   % smooth
        l = nsmsaidx(floor(k/2), 1);
        if sum(bgcolor) > 1.5
            color = 'b';
        else
            color = 'y';
        end
    end

    % Show maximum absolute value of this level
    plot([-0.03 -0.03 -0.02 -0.02 -0.03], ...
        2*k+0.3+[0 scaleymax(k+1) scaleymax(k+1) 0 0], 'color', color)

    if max(y) > 0,
        scaley = y/max(y)*1.5;
    else
        scaley = y;
    end;
    n = length(y);
    nn = 3*n;
    yy = zeros(nn+1,1);
    xx = yy;
    yy(2:3:nn) = scaley;
    yy(3:3:nn) = scaley;
    x = 0:1/length(y):1-1/length(y);
    if n > 1,
        delta = (max(x) - min(x)) / (n-1);
        t = x(:)';
        xx(1:3:nn) = t;
        xx(2:3:nn) = t;
        xx(3:3:nn) = t + delta;
        xx(nn+1) = xx(nn);
    else
        delta=0;
        xx(1)=0;
        xx(2)=0;
        xx(3)=1;
        xx(4)=1;
    end

    plot(xx,yy+2*k+.3, 'color',color)
    plot([0 1],[2*k 2*k]+.3, 'color',color)

    if indices
        if k <= 9,
            for i=l(1):l(2),
                if k > 1,
                    h = text((i-l(1)+0.5)*delta,2*k,sprintf('%d',i));
                else
                    h = text((i-l(1)+0.5),2*k,sprintf('%d',i));
                end
                set(h,'VerticalAlignment', 'bottom');    
                set(h,'HorizontalAlignment', 'center');    
            end
        else
            i=l(1);
            h = text((i-l(1))*delta,2*k,sprintf('%d',i));
            set(h,'VerticalAlignment', 'bottom');    
            i=l(2);
            h = text((i-l(1))*delta,2*k,sprintf('%d',i));
            set(h,'VerticalAlignment', 'bottom');    
        end
    end
    if (rem(k,2) == 0),
        h = text(-0.4,2*k,sprintf('d%g',floor(k/2)));
    else
        h = text(-0.4,2*k,sprintf('s%g',floor(k/2)));
    end
    %set(h,'Color',color)
    set(h,'HorizontalAlignment', 'right');
    set(h,'VerticalAlignment', 'bottom');    
    h = text(-0.35,2*k,sprintf('%e',max(y)));
    set(h,'VerticalAlignment', 'bottom');    
end

hold off


if nargout > 0
    ymaxx = ymax;
end
