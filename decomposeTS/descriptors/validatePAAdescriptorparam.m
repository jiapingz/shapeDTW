
function val_param = validatePAAdescriptorparam(param)

    if nargin == 0 || ~isstruct(param)
        val_param = struct('segNum', 10, ...
                           'segLen', [], ...
                           'priority', 'segNum');
        return;
    end

    val_param = validatePAAparam(param);
end