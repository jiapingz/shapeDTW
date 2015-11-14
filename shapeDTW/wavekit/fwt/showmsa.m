function showmsa(msa,options)

% SHOWMSA -- show information on different levels of a multiscale analysis
%
% showmsa(msa)
%
% msa is from fwt; it's length must be a power of 2.
%
% See also SHOWNSMS, PHASEPL, SHOWOPER.

% (C) 1993-1997 Harri Ojanen

% Number of msa-levels
% -----------------------------------------------------------------------
N = log(length(msa))/log(2)-1;
if N ~= round(N),
	error('Length of msa must be a power of 2.');
end

% Maximum absolute values at different levels
% -----------------------------------------------------------------------
ymax = zeros(N+2,1);
for k=-1:N,
	ymax(k+2) = max(abs(msalvl(msa,k)));
end

% -----------------------------------------------------------------------

% Scale maximum values
if max(ymax) > 0,
	ymax = ymax/max(ymax)*1.5;
end;
	% Set axis and vertical ruler

clf
plot([0 0],[-2 2*N+2])
axis([-0.03 1 -2 2*N+2])
hold on
set(gca,'Visible','off')

	% Horizontal ruler	
for i=1:2^6,
	plot([i/2^6 i/2^6], [-2,-1.85]);
end;
for i=1:2^3,
	plot([i/2^3 i/2^3], [-2,-1.7]);
end;

for k=-1:N,

	% Show maximum absolute value of this level
	plot([-0.03 -0.03 -0.02 -0.02 -0.03], ...
		2*k+[0 ymax(k+2) ymax(k+2) 0 0])
		y = abs(msalvl(msa,k));
	if max(y) > 0,
		y = y/max(y)*1.5;
	end;
	n = length(y);
	nn = 3*n;
	yy = zeros(nn+1,1);
	xx = yy;
	yy(2:3:nn) = y;
	yy(3:3:nn) = y;
	x = 0:1/length(y):1-1/length(y);
	if n > 1,
		delta = (max(x) - min(x)) / (n-1);
		t = x(:)';
		xx(1:3:nn) = t;
		xx(2:3:nn) = t;
		xx(3:3:nn) = t + delta;
		xx(nn+1) = xx(nn);
	else
		xx(1)=0;
		xx(2)=0;
		xx(3)=1;
		xx(4)=1;
	end

	plot(xx,yy+2*k)
	text(-0.08,2*k,sprintf('%g',k));
	plot([0 1],[2*k 2*k])
end

hold off
