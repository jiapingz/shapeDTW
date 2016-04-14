% difference with 'generateDescriptorFileName'
% this one is the file which stores descriptors of time series into disk
% while 'generateDescriptorFileName' is just an intermediate fileName
function descriptorFileName = ...
                    genDescriptorFileName(subsequencesFileName, descriptorName)
    error(nargchk(2,2,nargin));
	descriptorFileName = sprintf('%s-%s', subsequencesFileName, descriptorName);    
end