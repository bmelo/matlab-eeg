function preproc(config)

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.outdir_base, subj );
    
    %% PREPROC
    fprintf('\n####   PREPROC - %s   ####\n\n', subj);
    
    % Loading EEG/AUX - downsample to 500Hz
    [EEG, ~] = prepare_eeg(config, subj, config.srate);
    
    % removing some channels
    EEG = pop_select( EEG, 'channel', config.chs);
    
    % rereference to Cz
    EEG = pop_reref( EEG, 18 );
    
    % Epoching signal - using markers
    EEG.ext.epochs = epochs_v2( EEG );
    EEG.times = [];
    EEG.data = [];
    
    % Manipulating signal
    srate = EEG.srate;
    EEG = epochs_shrink(EEG); % Same size for all epochs
    
    % Two pass - outlier remotion
    EEG = epochs_apply(@remove_outliers, EEG, srate, srate*.04);
    EEG = epochs_apply(@remove_outliers, EEG, srate, srate*.04);
    
    % Working separated by bands (alpha, beta, gamma)
    srate = EEG.srate;
    bEEG = break_bands(EEG, config.bands);
    
    %% PROC
    pEEG = epochs_apply(@power_eeg, bEEG);
    erdEEG = epochs_apply(@erd_ers, bEEG, [srate*5 srate*10] );
    erdEEG = epochs_apply(@window_func, erdEEG, srate, floor(srate/5));
    
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