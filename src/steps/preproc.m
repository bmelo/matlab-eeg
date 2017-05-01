% Loading EEG/AUX - downsample to 500Hz
[EEG, ~] = prepare_eeg(config, subj, 500);
clear AUX;

% removing some channels
EEG = pop_select( EEG, 'channel', config.chs);
chs_new = 1:length(config.chs);

subjdir = fullfile( config.outdir_base, subj );
EEG.ext.epochs = epocas_v2( EEG );
EEG.times = [];
EEG.data = [];

% Manipulating signal
EEG = epochs_match_all(EEG);
cEEG = epochs_apply(@filter_bands, EEG, EEG.srate, [7 45]);
pEEG = epochs_apply(@power_eeg, cEEG);
erdEEG = epochs_apply(@erd_ers, cEEG, cEEG.srate, floor(cEEG.srate/5) );

% Saving global
eeg_save( fullfile(subjdir, 'pEEG_global'), pEEG );
eeg_save( fullfile(subjdir, 'syncEEG_global'), erdEEG );

clear pEEG erdEEG cEEG;
bEEG = break_bands(EEG, config.bands);
clear EEG;
pEEG = epochs_apply(@power_eeg, bEEG);
erdEEG = epochs_apply(@erd_ers, bEEG, bEEG(1).srate, floor(bEEG(1).srate/5) );

% Saving bands
for nB = 1:length(config.bands)
    sband = sprintf('%d_%d', config.bands(nB, :));
    eeg_save( fullfile(subjdir, ['pEEG_' sband]), pEEG(nB) );
    eeg_save( fullfile(subjdir, ['syncEEG_' sband]), erdEEG(nB) );
end