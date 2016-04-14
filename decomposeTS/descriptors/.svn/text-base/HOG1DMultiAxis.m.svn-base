
function descriptor = HOG1DMultiAxis(sensorData, param)
    % column-major
    % each column is data from one sensor
    % number of columns is the number of sensors
    nAxis = size(sensorData,2);
    descriptor = [];
    for i=1:nAxis
        desc = descriptorHOG1D(sensorData(:,i)', param);
        descriptor = cat(2, descriptor, desc);
    end
    
end