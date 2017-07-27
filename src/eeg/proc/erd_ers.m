function signalERD = erd_ers(signal, window_ref)
% ERD_ERS
% Input - EEG signal

signal = signal.^2;
relative_power = mean( signal(window_ref(1):window_ref(2)) );

% percentage difference
signalERD = 100 * (signal-relative_power) / relative_power;

end