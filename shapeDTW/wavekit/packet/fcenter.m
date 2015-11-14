function y = fcenter(h)

% FCENTER -- the center of a filter
%
% y = fcenter(h)

% (C) 1997 Harri Ojanen

h = h(:)';
k = 0 : length(h)-1;
y = sum(k .* h .^ 2);
