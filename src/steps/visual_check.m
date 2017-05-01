only_before = 0;

plot_overlap_task(EEG, 'raw', config.chs, 0, only_before);
plot_overlap_task(EEG, 'raw-mean', config.chs, 1, only_before);
plot_overlap_task(cEEG, 'high-low filtered', config.chs, 1, only_before);

%% Characteristics
% POWER
EEG_pow = epochs_apply(@power_eeg, cEEG);
plot_overlap_task(EEG_pow, 'power', chs_new, 0, only_before, @erd_ers, EEG.srate, floor(EEG.srate/5));

% ERD/ERS
%EEG_erd = epochs_apply( @erd_ers, EEG, EEG.srate, floor(EEG.srate/5) );
%plot_overlap_task(EEG_erd, 'ERD-ERS', chs, 0, extra);
bEEG = epochs_apply( @power_eeg, bEEG );
plot_bands_overlap_task(bEEG, 'ERD-ERS bands', chs_new, 0, only_before, @erd_ers, bEEG(1).srate, floor(bEEG(1).srate/5));
