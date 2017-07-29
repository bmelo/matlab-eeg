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
    
    % Filtering to stay with bands 7-45
    EEG = bands_apply(@filter_bands, EEG, EEG.srate, [7 45]);
    
    % Epoching signal - using markers
    EEG.ext.epochs = epochs_v2( EEG );
    EEG.times = [];
    EEG.data = [];
    
    % Manipulating signal
    srate = EEG.srate;
    EEG = epochs_shrink(EEG); % Same size for all epochs
    
    % Two pass - outlier remotion
    EEG = epochs_apply(@remove_outliers, EEG, srate, srate*.4);
    EEG = epochs_apply(@remove_outliers, EEG, srate, srate*.4);
    
    % Saving clean EEG
    eeg_save( subjdir, 'cEEG', EEG );
end

end