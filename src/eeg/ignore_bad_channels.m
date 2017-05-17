function [ EEG ] = ignore_bad_channels( EEG, remove_chs )
%IGNORE_BAD_CHANNELS Summary of this function goes here
%   Detailed explanation goes here

for nP = 1:length(EEG.ext.epochs.TASK_T)
    EEG.ext.epochs.TASK_T(nP).data(remove_chs, :) = NaN;
end

for nP = 1:length(EEG.ext.epochs.TASK_A)
    EEG.ext.epochs.TASK_A(nP).data(remove_chs, :) = NaN;
end


end

