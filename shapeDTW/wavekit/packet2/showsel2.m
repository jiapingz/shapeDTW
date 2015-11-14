function showsel2(w)

% SHOWSEL2 -- shows the selected basis textually
%
% showsel2(w)
%
% This is not really useful (unless you have absolutely no graphics),
% use  showwp2  instead.
%
% See also SHOWWP2.

% (C) 1997 Harri Ojanen

N = size(w.sel,1);
levels = size(w.sel,3);
a = zeros(N,N);

for i = 1 : levels
    a = a + i * double(w.sel(:,:,i));
end

if N >= 64

    for i = 1 : N
        fprintf('%d', a(i,1:N/4));
        fprintf(' ');
        fprintf('%d', a(i,N/4+1:N/2));
        fprintf('   ');
        fprintf('%d', a(i,N/2+1:3*N/4));
        fprintf(' ');
        fprintf('%d', a(i,3*N/4+1:N));
        if (rem(i,N/4) == 0) & (i ~= N)
            fprintf('\n');
        end
        fprintf('\n');
    end

elseif N >= 4

    for i = 1 : N
        fprintf(' %d', a(i,1:N/4));
        fprintf(' ');
        fprintf(' %d', a(i,N/4+1:N/2));
        fprintf('   ');
        fprintf(' %d', a(i,N/2+1:3*N/4));
        fprintf(' ');
        fprintf(' %d', a(i,3*N/4+1:N));
        if (rem(i,N/4) == 0) & (i ~= N)
            fprintf('\n');
        end
        fprintf('\n');
    end

else

    for i = 1 : N
        fprintf(' %d', a(i,:));
        fprintf('\n');
    end

end


