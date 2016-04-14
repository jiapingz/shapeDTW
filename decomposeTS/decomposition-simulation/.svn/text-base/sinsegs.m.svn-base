function curve =  sinsegs(fs, nfs, mags, length)
    
    notations = {'-', '+'};
    n = numel(fs);
    curve = zeros(1, length);
    for i=1:n
        f = fs(i);
        mag = mags(i);
        nf = nfs(i);
        [~,y] = segsin(f, nf, mag, length);
        str = ['curve=curve' notations{randi(2)} 'y'];
        eval(str);
    end
        

end