function signal = power_rel_eeg(signal)
% POWER_REL_EEG - Relative Power
% Details

power = power_eeg( signal );
signal = power / median(power);

end