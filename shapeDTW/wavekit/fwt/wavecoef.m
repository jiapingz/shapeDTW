function [h,g,h2,g2] = wavecoef(selection,n)

% WAVECOEF -- returns some wavelet filter coefficients
%
% [h,g] = wavecoef(selection,n)
% [h1,g1,h2,g2] = wavecoef(selection,n)
%
% selection  is the name of the family:
%  'Haar'       Haar's wavelet
%  'Beylkin'    Only one wavelet, with 18 coefficients
%  'Coiflet'    Coiflets 6, 12, 18, 24, and 30 (=n)
%  'Daubechies' Her compactly supported of length n (n=2,4,...,20)  
%  'Ojanen'     Most Sobolev-regular (see the documentation),
%               lengths n=8:2:40
%  'Vaidyanathan'  One wavelet with 24 coefficients
%  'Symmetric biorthogonal'   of orders n= 1.3, 1.5, 2.2, 2.4, 2.6, 
%               2.8, 3.3, 3.5, 3.7, and 3.9
% Output:
%  h    Filter coefficients for the scaling function
%  g    Coefficients for the corresponding wavelet
%
% With no input arguments returns the names of the families (the 
% biorthogonal wavelets are listed only when there are four output 
% arguments).
%
% If the user selects an orthogonal wavelet when there are four
% output arguments, h2 and g2 are copies of h and g.
%
% The first three letters are enough for  selection, which is also
% case insensitive.
%
% See also SELWAVLT, WAVDEMO.

% (C) 1993-1997 Harri Ojanen

globals = 'global BEYLKINHCOEFFS COIFLETHCOEFFS DAUBECHIESHCOEFFS OJANENHCOEFFS OJANENORDERS VAIDYANATHANHCOEFFS SYMMBIORTHGCOEFFS SYMMBIORTHHCOEFFS SYMMBIORTHORDERS';

if nargin == 0
    h = str2mat(...
        'Beylkin 18',...
        'Coiflet', ...
        'Daubechies', ...
        'Haar', ...
        'Ojanen (Sobolev smoothest)', ...
        'Vaidyanathan 24');
    g = [];
    g(1,1) = 0;
    g(2, 1:5) = [6 12 18 24 30];
    g(3, 1:10) = 2:2:20;
    g(4,1) = 0;
    eval(globals)
    if isempty(OJANENORDERS)
        load wavecoef.mat
    end
    g(5,1:length(OJANENORDERS)) = OJANENORDERS;
    g(6,1) = 0;

    if nargout == 3
        h = str2mat(h, 'Symmetric biorthogonal');    
        h2 = [zeros(size(g,1),1); 1];
        eval(globals)
        if isempty(SYMMBIORTHORDERS)
            load wavecoef.mat
        end
        ord = SYMMBIORTHORDERS;
        ord = ord(find(abs(ord - floor(ord)) > 1e-9));
        g(size(g,1)+1, 1:length(ord)) = ord;
    end

elseif ischar(selection)

    selection = lower(selection);
    g = []; h2 = []; g2 = [];
    
    if (all(selection(1:3) == 'haa')),
        h = [1 1]/sqrt(2);
    
    elseif (all(selection(1:3) == 'smo')),
        disp('Warning: wavecoef argument "smoothest" outdated');
        h=[
         0.2555640190003257263090, ...
         0.8871342823137242859285, ...
         0.992940080228052694370, ...
         0.158404769101227142529, ...
        -0.345983092265384187728, ...
        -0.042008435953881406233, ...
         0.120470473468142354485, ...
        -0.0101539590279807914587, ...
        -0.02299148043113658743707, ...
         0.006623343566910769233958] / sqrt(2);

    elseif strcmp(selection(1:3), 'oja')
        eval(globals)
        if isempty(OJANENHCOEFFS) | isempty(OJANENORDERS)
            load wavecoef.mat
        end
        if ~any(n == OJANENORDERS)
            error('wavecoef: index for choice "Ojanen" out of range')
        end
        i = find(n == OJANENORDERS);
        %h = OJANENHCOEFFS(i,1:n);
        h = OJANENHCOEFFS{i};
    
    elseif (all(selection(1:3) == 'bey'))
        eval(globals)
        if ~length(BEYLKINHCOEFFS)
                load wavecoef.mat
        end
        h = BEYLKINHCOEFFS;
    
    elseif (all(selection(1:3) == 'coi'))
        eval(globals)
        if ~length(COIFLETHCOEFFS)
                load wavecoef.mat
        end
        if ~any(n == [6 12 18 24 30])
            error('wavecoef: index for choice "coiflet" out of range');
        end
        h = COIFLETHCOEFFS(n/6,1:n);
    
    elseif (all(selection(1:3) == 'dau'))
        eval(globals)
        if ~length(DAUBECHIESHCOEFFS)
                load wavecoef.mat
        end
        if n < 1 | n > 2*size(DAUBECHIESHCOEFFS,1) | isodd(n)
            error('wavecoef: index for choice "Dau" out of range');
        end
        h = DAUBECHIESHCOEFFS(n/2,1:n);
    
    elseif (all(selection(1:3) == 'vai'))
        eval(globals)
        if ~length(VAIDYANATHANHCOEFFS)
                load wavecoef.mat
        end
        h = VAIDYANATHANHCOEFFS;

    elseif strcmp(selection(1:3), 'sym')
        eval(globals)
        if isempty(SYMMBIORTHHCOEFFS) | isempty(SYMMBIORTHGCOEFFS) ...
                | isempty(SYMMBIORTHORDERS)
            load wavecoef.mat
        end
        if ~any(abs(SYMMBIORTHORDERS - n) < 1e-9)
            error('wavecoef: index for choice "Symmetric" out of range.');
        end
        i = find(abs(SYMMBIORTHORDERS - n) < 1e-9) ...
                - find(abs(SYMMBIORTHORDERS - floor(n)) < 1e-9) + 1;
        h = SYMMBIORTHHCOEFFS{floor(n)}(i,:);
        g = SYMMBIORTHGCOEFFS{floor(n)}(1,:);
        h2 = SYMMBIORTHHCOEFFS{floor(n)}(1,:);
        g2 = SYMMBIORTHGCOEFFS{floor(n)}(i,:);
        nz = ~((h == 0) & (g == 0) & (h2 == 0) & (g2 == 0));
        h = h(nz);
        g = g(nz);
        h2 = h2(nz);
        g2 = g2(nz);

    else
        error('wavecoef: Unknown selection!')
    end

elseif isnumeric(selection) 
    % if the input is a vector return it and the mirror filter
    h = selection;
    g = []; h2 = []; g2 = [];
        
else

    error('wavecoef: incorrect input argument(s)');

end

if nargin > 0
    if isempty(g)
        M = length(h)/2;
        g(1:2*M) = (-1) .^ (0:2*M-1) .* h(2*M-(1:2*M)+1);
    end
    if isempty(h2) | isempty(g2)
        h2 = h;
        g2 = g;
    end

end
