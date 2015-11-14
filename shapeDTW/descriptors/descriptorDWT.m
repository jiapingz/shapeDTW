
function rep =  descriptorDWT(subsequence, param)
    
    val_param = validateDWTdescriptorparam(param);    
    subsequence = subsequence(:);
    seqlen = length(subsequence);
    % now only support subsequences withe length less than 1024
    refLens = 2.^(1:10);
    gaps = abs(refLens - seqlen);
    [~, idx] = min(gaps);
    newlen = 2^idx;
    
    if newlen < seqlen
        subsequence = subsequence(1:newlen);
    else
        subsequence = [subsequence; mean(subsequence)*ones(newlen - seqlen,1)];
    end
    
        
    selection = val_param.selection;
    numLevels = val_param.numLevels;
    n = val_param.n;
    
    [h,g] = wavecoef(selection,n);
    
    
    cntLevels = 0;
    
    w = [];
    s = subsequence;
    while (length(s) >= 4) && cntLevels < numLevels
      [sout, dout] = fwt1step(s, h, g);
      w = cat(1, dout, w);
      s = sout;
      cntLevels = cntLevels + 1;
    end
    
    if cntLevels == numLevels
        w = cat(1, sout, w);
        rep = w';
        return;
    elseif cntLevels < numLevels && length(s) < 4    
        [sout, dout] = fwt1step(s, h, g);
        w = cat(1, [sout; dout], w);
        rep = w';
        return;
    end
    
    
end