% WPSGIMP -- subroutine script for wpsig

% (C) 1997 Harri Ojanen

WPSIGTEMP = inputdlg('Enter name of variable in workspace','Import');
if length(WPSIGTEMP),
    WPSIGTEMP = WPSIGTEMP{1};
    WPSIGTEMP = eval(WPSIGTEMP, ...
	'wpsgerr(sprintf(''Variable %s does not exist.'', WPSIGTEMP))');
    if length(WPSIGTEMP)
        wpsig('import', WPSIGTEMP);
    end
end
clear WPSIGTEMP
