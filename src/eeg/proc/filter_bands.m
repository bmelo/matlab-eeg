function signal = filter_bands( signal, srate, bands )
%FILTER_BANDS Remove bands using butter filter
%   Detailed explanation goes here

%Filter to be used
[b,a] = butter(4, bands/(srate/2));

% Filtering
signal = filtfilt(b, a, double(signal));

end

