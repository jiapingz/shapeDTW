
function fileName = generateHOG1DFileName(param)
    if nargin == 0
        val_param = validateHOG1Dparam;
    else
        val_param = validateHOG1Dparam(param); 
    end
   
   fileName = sprintf('HOG-cellsize-%d-overlap-%d-xscale-%g', val_param.cells(2), ...
                              val_param.overlap, val_param.xscale);
end