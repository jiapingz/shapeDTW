
function tmp = plotCollage(D, patchsize, rc)

if(nargin < 2)
    error('Not enough input parameters. Input params: D, patchsize\n');
end


%% ========== determin whether it's a color patch or a gray patch =========
[n, npatches] = size(D);
sizeEdgey = patchsize(1);
sizeEdgex = patchsize(2);
if(round(n/(sizeEdgex*sizeEdgey)) == 1)
    colormode = 'gray';
    V = 1;
elseif( round(n/(sizeEdgex*sizeEdgey)) == 3)
    colormode = 'color';
    V = 3;
else
    error('Now we can only show images with 1 or 3 bands\n');
end

%% ========= normalize the data for visualization =======================

        p=4.5;
        M=max((D(:)));
        m=min((D(:)));
%         if (m >= 0)
%            me=0;
%            sig=sqrt(mean(((D(:))).^2));
%         else
%            me=mean(D(:));
%            sig=sqrt(mean(((D(:)-me)).^2));
%         end

        me=mean(D(:));
        sig=sqrt(mean(((D(:)-me)).^2));

        D=D-me;
        D=min(max(D,-p*sig),p*sig);
        M=max((D(:)));
        m=min((D(:)));
        D=(D-m)/(M-m);


%% ============ produce a large map using small patches ================= 
    K = size(D,2);

if ~exist('rc', 'var') || isempty(rc)
    nx = ceil(sqrt(K*patchsize(1)/patchsize(2)));
    ny = ceil(K/nx);
else
    nx = rc(1);
    ny = rc(2);
end

% nBins=floor(sqrt(K));
% tmp = zeros((sizeEdgey+1)*nBins+1,(sizeEdgex+1)*nBins+1,V);
 tmp = ones((sizeEdgey+1)*ny+1,(sizeEdgex+1)*nx+1,3);

 tmp(:,:,3) = 1.0;
 
flag = false; 
for ii = 1:ny
    if(flag == true)
        break;
    end
   for jj = 1:nx
      io=ii;
      jo=jj;
      offsetx=0;
      offsety=0;
      ii=mod(ii-1+offsetx,ny)+1;
      jj=mod(jj-1+offsety,nx)+1;
      if( (io-1)*nx+jo > K)
          flag = true;
          break;
      end
      patchCol=(D(1:n,(io-1)*nx+jo));      
      patchCol=reshape(patchCol, [sizeEdgey,sizeEdgex, V]);
      
      M=max((patchCol(:)));
      m=min((patchCol(:)));
  %    patchCol=1.0*(patchCol-m)/(M-m)+0.0;

      switch V
          case 1
              tmp((ii-1)*(sizeEdgey+1)+2:ii*(sizeEdgey+1),...
                 (jj-1)*(sizeEdgex+1)+2:jj*(sizeEdgex+1),:)=repmat(patchCol, [1,1,3]);
          case 3
              tmp((ii-1)*(sizeEdgey+1)+2:ii*(sizeEdgey+1),...
                 (jj-1)*(sizeEdgex+1)+2:jj*(sizeEdgex+1),:) = patchCol;
      end
      ii=io;
      jj=jo;
   end
end

figure(1);
[hei, wid,c] = size(tmp);
if(hei > wid)
    Wh = 600;
    Ww = 600*wid/hei;
else
    Ww = 600;
    Wh = 600*hei/wid;
end

% imshow(tmp,'border','tight','initialmagnification','fit');
set(gcf,'Position',[500,400,Ww,Wh]);
% set(gca, 'units', 'pixel');
set(gca,'position',[0,0,1,1]);
set(gcf,'PaperPositionMode','auto');

colormap('bone');
imagesc(tmp);
set(gca,  'xtick',[], 'xticklabel', [], 'ytick',[] , 'yticklabel', [], 'XColor', [0 0 0], 'YColor', [0 0 0])  ;
axis square;
axis equal;
set (gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);

% imshow(tmp);


end