function preproc(config)
%PREPROC

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.preproc_dir, subj );
    
    fprintf('\n####   PREPROC - %s   ####\n\n', subj);
    
    % Loading EEG/AUX - downsample to 500Hz
    [EEG, ~] = prepare_eeg(config, subj, config.srate);
    
    % removing some channels
    EEG = pop_select( EEG, 'channel', config.chs);
    
    % rereference to Cz
    %EEG = pop_reref( EEG, 18 );
    
    % Notch filter
    notch_fs = utils.Var.get(config.preproc, 'notch');
    if notch_fs > 0
        EEG = channels_apply(@notch_filter, EEG, EEG.srate, notch_fs);
    end
    
    % Filtering High and Low pass filter
    EEG = channels_apply(@filter_bands, EEG, EEG.srate, config.preproc.filter);
    
    % Epoching signal - using markers
    EEG.ext.epochs = epochs_v2( EEG );
    EEG.times = [];
    EEG.data = [];
    
    % Manipulating signal
    srate = EEG.srate;
    EEG = epochs_shrink(EEG); % Same size for all epochs
    
    % Two pass - outlier remotion
    EEG = epochs_apply(@remove_outliers, EEG, srate, srate*.5);
    EEG = epochs_apply(@remove_outliers, EEG, srate, srate*.5);
    
    % Saving clean EEG
    eeg_save( subjdir, 'cEEG', EEG );
end

end