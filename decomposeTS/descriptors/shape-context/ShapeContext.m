%function [BH,mean_dist]= ShapeContext(Bsamp,Tsamp,mean_dist,nthetaBins,rnBins,rmin,rmax,out_vec, param)

function [BH, scInfo] = ShapeContext(subsequence, param)
% compute shape context descriptor for an input subsequence    
    narginchk(1,2);
    if ~exist('param','var') || isempty(param)
        scParam = validateShapeContextparam;
    else
        scParam = validateShapeContextparam(param);
    end

% (1) parameter for shape context descriptor 
%     scParam     =   validateShapeContextparam(param);
    xscale      =   scParam.xscale;
    nrBins      =   scParam.nrBins;
    nthetaBins  =   scParam.nthetaBins;
    rmin        =   scParam.rmin;
    rmax        =   scParam.rmax;
    tanTheta    =   scParam.tanTheta;
    isRotateInv =   scParam.isRotateInv;
    
% (2) scale x coordinates    
    seqlen = length(subsequence);
    nsamp = seqlen;
    x = 1:seqlen;
    x = xscale * x;
%     rmin = x(1)/2;    
    y = subsequence;
    Bsamp = [x(:)'; y(:)'];
    
% (3) compute shape context descriptor
    midIdx = ceil(seqlen/2);
    refPt = Bsamp(:,midIdx);
    
    r_array = sqrt(sum((Bsamp - repmat(refPt, 1, seqlen)).^2,1));
    theta_array_abs = atan2( Bsamp(2,:) - refPt(2), Bsamp(1,:) - refPt(1));
    if isRotateInv 
        theta_array = theta_array_abs - tanTheta;
    else
        theta_array = theta_array_abs;
    end
    
    % use a log. scale for binning the distances
    r_bin_edges=logspace(log10(rmin),log10(rmax),nrBins);
    r_array_q=zeros(1,nsamp);
    for m=1:nrBins
       r_array_q=r_array_q+(r_array<r_bin_edges(m));
    end
    fz=r_array_q>0; % flag all points inside outer boundary

    % put all angles in [0,2pi) range
    theta_array_2 = rem(rem(theta_array,2*pi)+2*pi,2*pi);
    % quantize to a fixed set of angles (bin edges lie on 0,(2*pi)/k,...2*pi
    theta_array_q = 1+floor(theta_array_2/(2*pi/nthetaBins));

    nbins=nthetaBins*nrBins;
    BH=zeros(1,nbins);
 
   fzn=fz(1,:);
   Sn=sparse(theta_array_q(1,fzn),r_array_q(1,fzn),1,nthetaBins,nrBins);
   BH(1,:)=Sn(:)';
   
   scInfo.sc         = BH;
   scInfo.ts         = Bsamp;
   scInfo.nrBins     = nrBins;
   scInfo.rBins      = r_bin_edges;
   scInfo.nthetaBins = nthetaBins;
   scInfo.thetaBins  = linspace(0, 2*pi, nthetaBins+1);
 
    
        
    
% [BH,mean_dist]=sc_compute(Bsamp,Tsamp,mean_dist,nbins_theta,nbins_r,r_inner,r_outer,out_vec);
%
% compute (r,theta) histograms for points along boundary 
%
% Bsamp is 2 x nsamp (x and y coords.)
% Tsamp is 1 x nsamp (tangent theta)
% out_vec is 1 x nsamp (0 for inlier, 1 for outlier)
%
% mean_dist is the mean distance, used for length normalization
% if it is not supplied, then it is computed from the data
%
% outliers are not counted in the histograms, but they do get
% assigned a histogram
%

end