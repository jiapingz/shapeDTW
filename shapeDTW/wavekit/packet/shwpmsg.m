function shwpmsg(s,c)

% SHWPMSG -- displays a message string, used by showwp
%
% Not intended to be used by the user.
%
% shwpmsg(string, color)
%
% See also SHOWWP.

% (C) 1997 Harri Ojanen

subplot(211);

if strcmp(version, '4.0')
    xlabel(s)
else
    xlabel(s,'color',c)
end

