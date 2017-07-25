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
    EEG = epochs_shrink(EEG); % Same size for all epochs
    srate = EEG.srate;
        
    %% Working separated by bands (alpha, beta, gamma)
    bEEG = break_bands(EEG, config.bands);
    bEEG = epochs_apply(@remove_outliers, bEEG, srate, 200);
    clear EEG;
    pEEG = epochs_apply(@power_eeg, bEEG);
    erdEEG = epochs_apply(@erd_ers, bEEG, srate, floor(srate/5), [srate*5 srate*10] );
    
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