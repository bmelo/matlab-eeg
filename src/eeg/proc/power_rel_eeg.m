function signal = power_rel_eeg( signal, power_global )
% POWER_REL_EEG - Relative Power
% Details

power = power_eeg( signal );
signal = power ./ power_global;

end