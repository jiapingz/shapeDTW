
% calculate descriptors:
% (1) HOG-1D;
% (2) Baydogan's
% (3) Windau
% (4) self
% (5) PLA
% (6) dePLA
% (7) PAA
% (8) DFT
% (9) DWT
% (10) HOG1DPAA
% (11) SlopePAA
% (12) Slope
% (13) HOG1DDWT
% (14) Gradient
% (15) GradientSelf
% (16) HOG1DDSP
% (17) ShapeContext

function descriptor = calcDescriptor(subsequence, descriptorName, param)
    narginchk(1,3);
    if numel(subsequence) ~= length(subsequence)
        error('The input subsequence should be one-dimensional\n');
    end
    
    if nargin == 1
        descriptorName = 'HOG1D';
        param = validateHOG1Dparam;
    end
    
    switch descriptorName
        case 'HOG1D'
            val_param   = validateHOG1Dparam(param);
            descriptor  = descriptorHOG1D(subsequence, val_param);
        case 'Windau'
%             val_param   = validateWindauparam(param);
%             bGravityDirection = val_param.bYDirection;
            descriptor  = descriptorWindau(subsequence);
        case 'Baydogan'
            val_param   = validateBaydoganparam(param);
            descriptor  = descriptorBaydogan(subsequence, val_param);
        case 'PAA'
            val_param   = validatePAAdescriptorparam(param);
            descriptor  = descriptorPAA(subsequence, val_param);
        case 'PLA'
            val_param   = validatePLAdescriptorparam(param);
            descriptor  = descriptorPLA(subsequence, val_param);
        case 'dePLA'
            val_param   = validatedePLAdescriptorparam(param);
            descriptor  = descriptordePLA(subsequence, val_param);
        case 'self'
            descriptor  = descriptorSelf(subsequence); 
        case 'SlopePAA'
            val_param   = validateSlopePAAdescriptorparam(param);
            descriptor  = descriptorSlopePAA(subsequence, val_param);
        case 'HOG1DPAA'
            val_param   = validateHOG1DPAAdescriptorparam(param);
            descriptor  = descriptorHOG1DPAA(subsequence, val_param);
        case 'HOG1DDWT'
            val_param   = validateHOG1DDWTdescriptorparam(param);
            descriptor  = descriptorHOG1DDWT(subsequence, val_param);
        case 'DFT'
            val_param   = validateDFTdescriptorparam(param);
            descriptor  = descriptorDFT(subsequence, val_param);
        case 'DWT'
            val_param   = validateDWTdescriptorparam(param);
            descriptor  = descriptorDWT(subsequence, val_param);   
        case 'Slope'
            val_param   = validateSlopedescriptorparam(param);
            descriptor  = descriptorSlope(subsequence, val_param);
        case 'Gradient'
            val_param   = validateGradientdescriptorparam(param);
            descriptor  = descriptorGradient(subsequence, val_param);
        case 'GradientSelf'
            val_param   = validateGradSelfdescriptorparam(param);
            descriptor  = descriptorGradSelf(subsequence, val_param);
        case 'HOG1DDSP'
            val_param   = validateHOG1DDSPparam(param);
            descriptor  = descriptorHOG1DDSP(subsequence, val_param);
            
        case 'ShapeContext'
            val_param   = validateShapeContextparam(param);
            descriptor  = descriptorShapeContext(subsequence, val_param);
            
        otherwise
            error('Only support 17 descriptors\n');
    end
    
end