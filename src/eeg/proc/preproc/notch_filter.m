function [ signal ] = notch_filter( signal, srate, freq )
%NOTCH_FILTER Summary of this function goes here
%   Detailed explanation goes here

try
    d = designfilt('bandstopiir','FilterOrder',2, ...
        'HalfPowerFrequency1', (freq-1), 'HalfPowerFrequency2', (freq+1), ...
        'DesignMethod','butter','SampleRate', srate);
    signal = filtfilt(d, double(signal));

% For old MATLAB
catch e
    fspec = fdesign.notch('N,F0,Q,Ap', 6, freq, 30, 0.5, srate);
    d = design(fspec);
    signal = filter(d, signal);
end

end

