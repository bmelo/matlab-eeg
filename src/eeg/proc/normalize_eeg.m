function signal = normalize_eeg(signal)
% NORMALIZE SIGNAL
% signal will be normalized by subtracting the mean value and dividing by the variance

meanE = mean(signal);
varE  = var(signal);

signal = (signal - meanE);

if abs(varE) > 0.1 && abs(varE) < 200
    signal = signal / varE;
else
    disp(varE);
end

end