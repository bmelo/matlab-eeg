function preproc(config)
%PREPROC
outlier_sd = utils.Var.get(config, 'outlier_sd', 2);
w_size = utils.Var.get(config, 'window_size', config.srate);
w_overlap = utils.Var.get(config, 'window_overlap', w_size * .5);

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.preproc_dir, subj );
    if ~isdir(subjdir), mkdir(subjdir); end
    
    fprintf('\n####   PREPROC - %s   ####\n\n', subj);
    
    % Loading EEG/AUX - downsample
    [EEG, ~] = prepare_eeg(config, subj, config.srate);
    
    % removing some channels - keeping 63 EEG channels
    EEG = pop_select( EEG, 'channel', config.chs);
    
    % rereference to Cz
    %EEG = pop_reref( EEG, 18 );
    
    % Notch filter
    notch_fs = utils.Var.get(config.preproc, 'notch');
    if notch_fs > 0
        EEG = channels_apply(@notch_filter, EEG, EEG.srate, notch_fs);
    end
    
    % Filtering High and band pass filter
    EEG = channels_apply(@filter_bands, EEG, EEG.srate, config.preproc.filter);
    
    % Epoching signal - using markers
    EEG.ext.epochs = epochs_v2( EEG );
    EEG.times = [];
    EEG.data = [];
    
    % Manipulating signal
    srate = EEG.srate;
    EEG = epochs_shrink(EEG); % Same size for all epochs
    
    % Two pass - outlier remotion
    EEG = epochs_apply(@remove_outliers, EEG, outlier_sd, w_size, w_overlap);
    EEG = epochs_apply(@remove_outliers, EEG, outlier_sd, w_size, w_overlap);
    
    % Saving clean EEG
    name_srate = sprintf('cEEG_%d', srate);
    eeg_save( subjdir, name_srate, EEG );
    all_bands = [config.bands; config.band_global];
    
    % Saving each band
    for nB = 1:size(all_bands, 1)
        band = all_bands(nB, :);
        bEEG = epochs_apply( @filter_bands, EEG, EEG.srate, band );
        bEEG.ext.bands = band;
        
        % Two pass - outlier remotion
        if ~config.debug
            bEEG = epochs_apply(@remove_outliers, bEEG, outlier_sd, w_size, w_overlap);
            bEEG = epochs_apply(@remove_outliers, bEEG, outlier_sd, w_size, w_overlap);
        end
        
        % Saving EEG bands
        eeg_save( subjdir, gen_filename('cEEG', band, srate), bEEG );
    end
end

end