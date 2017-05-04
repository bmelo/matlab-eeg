function EEG = epochs_shrink( EEG, duracao )
%EPOCHS_SHRINK Summary of this function goes here
%   Detailed explanation goes here

if nargin<2, duracao=0; end

signal = EEG.ext.epochs;

%signal.NEUTRAL = match_length(signal.NEUTRAL, 1);
signal.TASK_T = match_length(signal.TASK_T, 0, duracao);
signal.TASK_A = match_length(signal.TASK_A, 0, duracao);

EEG.ext.epochs = signal;

end

