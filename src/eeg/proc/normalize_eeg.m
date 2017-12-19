function signal = normalize_eeg(signal)
% NORMALIZE SIGNAL
% signal will be normalized by subtracting the mean value and dividing by the variance

meanE = mean(signal);
varE  = var(signal);

signal = (signal - meanE)/varE;

end