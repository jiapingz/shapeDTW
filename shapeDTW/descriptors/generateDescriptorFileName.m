
function fileName =  generateDescriptorFileName(descriptorName, param)
% generate descriptor fileName:
% (1) HOG-1D;
% (2) Baydogan's
% (3) Windau
% (4) self
% (5) PLA
% (6) dePLA
% (7) PAA
% (8) HOG1DPAA
% (9) Slope
% (10) SlopePAA
% (11) DFT
% (12) DWT
    if nargin == 1
        descriptorName = 'HOG1D';
    end
    
    switch descriptorName
        case 'HOG1D'
            fileName = generateHOG1DFileName(param);
        case 'Windau'
            fileName = generateWindauFileName(param);

        case 'Baydogan'
            fileName = generateBaydoganFileName(param);
            
        case 'PAA'
            fileName = generatePAAdescriptorFileName(param);
            
        case 'PLA'
            fileName = generatePLAdescriptorFileName(param);
            
        case 'dePLA'
            fileName = generatedePLAdescriptorFileName(param);
            
        case 'self'
            fileName = generateSelfFileName;  
        case 'Slope'
            fileName = generateSlopedescriptorFileName(param);
        case 'SlopePAA'
            fileName = generateSlopePAAdescriptorFileName(param);
        case 'DFT'
            fileName = generateDFTdescriptorFileName(param);
        case 'DWT'
            fileName = generateDWTdescriptorFileName(param);
        case 'HOG1DPAA'
            fileName = generateHOG1DPAAFileName(param);
        otherwise
            error('Only support 12 kinds of descriptors\n');
    end
    
 
end