% dynamic time warping
% input:  sequence s;
%         sequence t;
%         local constraint window size w;

% output 
%          dist: dtw distance
%          dMat: distance matrix
%          lPath: length of the matching path
%          match: a sequence of match points

function [dist,dMat,lPath,match] = dtw_locality(s,t,w)

    narginchk(2,3);
    if nargin<3
        w=Inf;
    end

    if isvector(s) && isvector(t)
        s = s(:);
        t = t(:);
    elseif ismatrix(s) && ismatrix(t)
        [s1,s2] = size(s);
        [t1,t2] = size(t);

        if s1 < s2 || t1 < t2
            warning('Make sure the signals are arranged column-wisely\n');
        end
        
        if s2 ~= t2
            error('Two inputs have different dimensions\n');
        end
    else
        error('Only support vector or matrix inputs\n');
        
    end
     
    
    ns=length(s);
    nt=length(t);
    w=max(w, abs(ns-nt)); % adapt window size

    %% initialization
    dMat=zeros(ns+1,nt+1)+Inf; % cache matrix
    dMat(1,1)=0;

    %% begin dynamic programming
    
    for i=2:ns+1
        for j=max(i-w,2):min(i+w,nt+1)
            oost=norm(s(i-1,:)-t(j-1,:));
            dMat(i,j)=oost+min( [dMat(i-1,j), dMat(i-1,j-1), dMat(i,j-1)] );

        end
    end
    dist=dMat(ns+1,nt+1);
    
    dMat = dMat(2:ns+1,2:nt+1);
    
    %% back track to get the matched path
    lPath = 1;
    match=[];
    N = ns;
    M = nt;
    match(1,:)=[N,M];
    n = N;
    m = M;
    while ((n+m)~=2)
        if (n-1)==0
            m=m-1;
        elseif (m-1)==0
            n=n-1;
        else 
          [~,number]=min([dMat(n-1,m),dMat(n,m-1),dMat(n-1,m-1)]);
          switch number
              case 1
                n=n-1;
              case 2
                m=m-1;
              case 3
                n=n-1;
                m=m-1;
          end
        end
        lPath=lPath+1;
        match=cat(1,match,[n,m]);
    end

    match = match(lPath:-1:1, :);    
end
