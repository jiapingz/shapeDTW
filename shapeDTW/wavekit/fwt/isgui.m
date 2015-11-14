function y = isgui

% isgui -- returns 1 if the interface can display GUIs, 0 if text based

y = 1;

if isunix
    y = length(getenv('DISPLAY')) > 0;
elseif isvms
    y = length(getenv('DECW$DISPLAY')) > 0;
end
