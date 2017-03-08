function EEG = epochs_match_all(EEG)
% MATCH_ALL_LENGTH Leaves each piece with the same size

signal = EEG.ext.epochs;

signal.NEUTRAL = match_length(signal.NEUTRAL, 1);
signal.TASK_T = match_length(signal.TASK_T);
signal.TASK_A = match_length(signal.TASK_A);

EEG.ext.epochs = signal;

end