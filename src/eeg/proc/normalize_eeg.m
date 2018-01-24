function signal = normalize_eeg(signal)
% NORMALIZE SIGNAL
% signal will be normalized by subtracting the mean value and dividing by the variance

meanE = mean(signal);
signal = (signal - meanE);

varE  = var(signal);

if abs(varE) > 0.1% && abs(varE) < 200
    signal = signal / varE;
elseif ~isnan(varE)
    disp(varE);
end

end