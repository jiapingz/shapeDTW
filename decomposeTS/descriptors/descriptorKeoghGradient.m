function grads = descriptorKeoghGradient(seq)
    
    grads = calcKeoghGradient1D(seq);
    grads = grads(:)';

end