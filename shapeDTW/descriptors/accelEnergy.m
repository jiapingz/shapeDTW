% compute energy of acceleration

function accEnergy = accelEnergy(accel)
    
    fftAccel = fft(accel, [], 2);
    magFFTaccel = abs(fftAccel);
    me = mean(magFFTaccel.^2,1);
    accEnergy = mean(me);
    
end