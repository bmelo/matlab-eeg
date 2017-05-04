function preproc(config)

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.outdir_base, subj );
    
    fprintf('\n####   PREPROC - %s   ####\n\n', subj);
    
    %% EEG just filtered [7 45] Hz
    % Loading EEG/AUX - downsample to 500Hz
    [EEG, ~] = prepare_eeg(config, subj, config.srate);
    
    % removing some channels
    EEG = pop_select( EEG, 'channel', config.chs);
    
    EEG.ext.epochs = epocas_v2( EEG );
    EEG.times = [];
    EEG.data = [];
    
    % Manipulating signal
    EEG = epochs_shrink(EEG);
    cEEG = epochs_apply(@filter_bands, EEG, EEG.srate, [7 45]);
    pEEG = epochs_apply(@power_eeg, cEEG);
    erdEEG = epochs_apply(@erd_ers, cEEG, cEEG.srate, floor(cEEG.srate/5) );
    
    % Saving global
    eeg_save( subjdir, 'pEEG_global', pEEG );
    eeg_save( subjdir, 'syncEEG_global', erdEEG );
    
    
    %% Working separated by bands (alpha, beta, gamma)
    clear pEEG erdEEG cEEG;
    bEEG = break_bands(EEG, config.bands);
    clear EEG;
    pEEG = epochs_apply(@power_eeg, bEEG);
    erdEEG = epochs_apply(@erd_ers, bEEG, bEEG(1).srate, floor(bEEG(1).srate/5) );
    
    % Saving bands
    for nB = 1:length(config.bands)
        sband = sprintf('%d_%d', config.bands(nB, :));
        eeg_save( subjdir, ['pEEG_' sband], pEEG(nB) );
        eeg_save( subjdir, ['syncEEG_' sband], erdEEG(nB) );
    end
    
    fprintf('\n\n');
    clear EEG AUX cEEG bEEG bEEG_erd;
end

end