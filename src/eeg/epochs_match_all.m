function EEG = epochs_match_all(EEG)
% MATCH_ALL_LENGTH Leaves each piece with the same size

if nargin<2, duracao=0; end

signal = EEG.ext.epochs;

%signal.NEUTRAL = match_length(signal.NEUTRAL, 1);
signal.TASK_T = match_length(signal.TASK_T, 0, duracao);
signal.TASK_A = match_length(signal.TASK_A, 0, duracao);

EEG.ext.epochs = signal;

end