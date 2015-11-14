
function fileName = generateWindauFileName(param)
    if nargin == 0
        val_param = validateWindauparam;
    else
        val_param = validateWindauparam(param);
    end
    
    fileName = sprintf('Windau');
    
end