function [ signal ] = notch_filter( signal, srate, freq )
%NOTCH_FILTER Summary of this function goes here
%   Detailed explanation goes here

try
    d = designfilt('bandstopiir','FilterOrder',2, ...
        'HalfPowerFrequency1', (freq-1), 'HalfPowerFrequency2', (freq+1), ...
        'DesignMethod','butter','SampleRate', srate);
catch e
    d = fdesign.notch('N,F0,Q,Ap', 6, freq, 30, 0.5, srate);
end

% Apply filter
signal = filtfilt(d, double(signal));

end

