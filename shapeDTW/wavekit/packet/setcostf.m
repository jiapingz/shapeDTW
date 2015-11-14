function setcostf(action)

% SETCOSTF -- displays a menu for selecting the cost function
%
% See also BESTBASE, BESTBAS2, COSTFN.

% (C) 1997 Harri Ojanen

global COSTFN;
if ~length(COSTFN)
    COSTFN = 2000;
end

if ~isgui
	if COSTFN < 1000
	    s = sprintf('Lp with p = %g', COSTFN);
	elseif COSTFN == 2000
	    s = sprintf('L2 entropy');
	elseif COSTFN >= 3000 & COSTFN < 4000
	    s = sprintf('Threshold with threshold = %g',...
		 COSTFN-3000);
	else
	    s = 'Unknown cost function?!';
	end	
	fprintf('Current cost function is:\n%s\n', s);

	choices = {
		'Lp ...',...
		'L2 entropy',...
		'Threshold ...'};
	commands = {
	  'COSTFN = ask(''p'', ''Lp cost function'');', ...
	  'COSTFN = 2000;', ...
	  'COSTFN = ask(''threshold'', ''Threshold cost function'')+3000;'};
	k = menu('Select cost function', choices);
	eval(commands{k})
	return
end


if nargin == 0
    action = 'init';
end

switch action
    case 'init'
	setcosff
	fixpos
	if COSTFN < 1000
	    set(findobj(gcf, 'tag', 'Lp'), 'value', 1);
	    set(findobj(gcf, 'tag', 'text'), 'string', 'p = ?');
	    set(findobj(gcf, 'tag', 'edit'), 'string', num2str(COSTFN));
	elseif COSTFN == 2000
	    set(findobj(gcf, 'tag', 'L2 entropy'), 'value', 1);
	    set(findobj(gcf, 'tag', 'edit'), 'string', '');
	elseif (COSTFN >= 3000) & (COSTFN < 4000)
	    set(findobj(gcf, 'tag', 'Threshold'), 'value', 1);
	    set(findobj(gcf, 'tag', 'text'), 'string', 'Threshold = ?');
	    set(findobj(gcf, 'tag', 'edit'), 'string', num2str(COSTFN-3000));
	end

	set(gcf, 'handlevisibility', 'callback');

    case 'Lp'
	set(findobj(gcbf, 'tag', 'text'), 'string', 'p = ?');
	set(findobj(gcf, 'tag', 'Lp'), 'value', 1);
	set(findobj(gcf, 'tag', 'L2 entropy'), 'value', 0);
	set(findobj(gcf, 'tag', 'Threshold'), 'value', 0);
	if COSTFN < 1000
	    set(findobj(gcf, 'tag', 'edit'), 'string', num2str(COSTFN));
	else
	    set(findobj(gcf, 'tag', 'edit'), 'string', '');
	end

    case 'L2entropy'
	set(findobj(gcbf, 'tag', 'text'), 'string', '');
	set(findobj(gcf, 'tag', 'Lp'), 'value', 0);
	set(findobj(gcf, 'tag', 'L2 entropy'), 'value', 1);
	set(findobj(gcf, 'tag', 'Threshold'), 'value', 0);
	set(findobj(gcf, 'tag', 'edit'), 'string', '');

    case 'threshold'
	set(findobj(gcbf, 'tag', 'text'), 'string', 'Threshold = ?');
	set(findobj(gcf, 'tag', 'Lp'), 'value', 0);
	set(findobj(gcf, 'tag', 'L2 entropy'), 'value', 0);
	set(findobj(gcf, 'tag', 'Threshold'), 'value', 1);
	if (COSTFN >= 3000) & (COSTFN < 4000)
	    set(findobj(gcf, 'tag', 'edit'), 'string', num2str(COSTFN-3000));
	else
	    set(findobj(gcf, 'tag', 'edit'), 'string', '');
	end

    case 'ok'	
	if get(findobj(gcf, 'tag', 'Lp'), 'value')
	    s = eval(get(findobj(gcf, 'tag', 'edit'), 'string'), 'nan');
	    if isok(s)
		COSTFN = s;
	        close(gcbf)
	    end
    	
	elseif get(findobj(gcf, 'tag', 'L2 entropy'), 'value')
	    COSTFN = 2000;
	    close(gcbf)

	elseif get(findobj(gcf, 'tag', 'Threshold'), 'value')
	    s = eval(get(findobj(gcf, 'tag', 'edit'), 'string'), 'nan');
	    if isok(s)
		COSTFN = s+3000;
	        close(gcbf)
	    end
	end
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = isok(s)

y = all(isfinite(s)) & (length(s) == 1);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function y = ask(prompt, title)

disp(title);    
y = input([prompt ' = ']);
