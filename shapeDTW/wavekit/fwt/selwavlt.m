function [outh,outg,outh2,outg2] = selwavlt(inh, ing, inh2, ing2)

% SELWAVLT -- select wavelet filter coefficients from a menu
%
% [h,g] = selwavlt
% [h1,g1,h2,g2] = selwavlt
%
% The user is presented with a menu of all different wavelets that
% the wavecoef program knows about. The filter coefficients for the
% selected wavelet are returned.
%
% The second form with four output arguments provides access also to 
% biorthogonal wavelets. The pair h1,g1 is used for analysis and
% h2,g2 for synthesis. (If the user selects an orthogonal wavelet
% then h2 is a copy of h2 and g2 a copy of g1.)
%
% If the user presses 'cancel', empty vectors are returned.
%
% [h,g] = selwavlt(H,G)
% [h1,g1,h2,g2] = selwavlt(H1,G1,H2,G2)
% [h1,g1,h2,g2] = selwavlt(H1,G1)
%
% If the user presses 'cancel', the vectors H and G are returned (or 
% H1,...,G2 in the second case which includes also biorthogonal 
% wavelets). The third case is used when the input wavelet described
% by H1,G1 is orthogonal.
%
% See also WAVECOEF, WAVDEMO.

% (C) 1997 Harri Ojanen

if ~any(nargout == [0 1 2 4])
    error('wavecoef: incorrect number of output arguments')
end
if ~any(nargin == [0 2 4])
    error('wavecoef: incorrect number of input arguments')
end


if isgui

    fig = selwavlc(nargout == 4);	
    uiwait(fig);
    U = get(fig, 'userdata');
    h = U.h;
    g = U.g;
    h2 = U.h2;
    g2 = U.g2;
    close(fig);
        
else %%%%%%%%%%%%%%%%%%%%%%%%% not gui, use text menu %%%%%%%%%%%%%%%

    if nargout == 2	
        [names, indices] = wavecoef;
    else
        [names, indices, biorth] = wavecoef;
    end
    
    str = 'menu(''Select wavelet (family)''';
    for i = 1:size(names,1)
        str = [str ',''' names(i,:) ''''];
    end;
    str=[str ',''Cancel'')'];
    wav = eval(str);

    if wav <= size(names, 1)
        if any(indices(wav, :))
            str = ['menu(''Select index (' deblank(names(wav,:)) ')'''];
            for i = 1:size(indices, 2)
                if ~indices(wav, i), break, end;
                str = [str ',''' num2str(indices(wav, i)) ''''];
            end
            str=[str ')'];
            n = eval(str);
            [h,g,h2,g2] = wavecoef(names(wav, :), indices(wav, n));
        else
            [h,g,h2,g2] = wavecoef(names(wav, :));
        end
    
    else
    
        h = []; g = []; h2 = []; g2 = [];
    
    end

end

        
if length(h)             % user accepted a choice from the window/menu
    outh = h;
    outg = g;
    outh2 = h2;
    outg2 = g2;
elseif nargin >= 2       % canceled, if input args given, return those
    outh = inh;
    outg = ing;
    if nargin == 4      
        outh2 = inh2;
        outg2 = ing2;
    else
        outh2 = inh;     % if not enough input args, copy what was given
        outg2 = ing;     % (that will be ok for orthogonal wavelets)
    end
else
    outh = [];           % cancel and no input args given
    outg = [];    
    outh2 = [];
    outg2 = [];
end    
