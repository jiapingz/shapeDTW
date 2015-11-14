function seq_grad = calcKeoghGradient1D(sequence)
% calculate gradient defined by Keogh, 2001 
% grad(q_i) = [( q_i - q_{i-1} ) + ( q_{i+1} - q_{i-1})/2 )]/2

% in order to make the gradient sequence of the same length as the original
% sequence, we pad both ends of the sequence

    if ~exist('sequence', 'var') || nargin ~= 1
        error('Please input an univariate time series instance\n');
    end
    
    
    seq = sequence(:);
    seq_pad = [seq(1); seq; seq(end)];
    len = length(seq_pad);
    
    seq_grad = (seq_pad(2:(len-1)) - seq_pad(1:(len-2))) + ...
                    (seq_pad(3:len) - seq_pad(1:(len-2)))/2;
    seq_grad = seq_grad /2;

end