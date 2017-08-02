function extract_features( config )
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes here

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.preproc_dir, subj );

    fprintf('\n####   FEATURE EXTRACTION - %s   ####\n\n', subj);
    EEG = eeg_load( subjdir, 'cEEG' );
    srate = EEG.srate;
    
    % Spectral Density
    if config.proc.features.density
        for nB = 1:length(config.bands)
            densEEG(nB) = epochs_apply(@window_func, EEG, srate, srate/2, ...
                @spectral_density, srate, srate, [], config.bands(nB,:));
            sband = sprintf('%d_%d', config.bands(nB, :));
            eeg_save( subjdir, ['densEEG_' sband], densEEG(nB) );
        end
    end
    
    % Working separated by bands (alpha, beta, gamma)
    bEEG = break_bands(EEG, config.bands);
    % Two pass - outlier remotion
    bEEG = epochs_apply(@remove_outliers, bEEG, srate, srate*.4);
    bEEG = epochs_apply(@remove_outliers, bEEG, srate, srate*.4);
    
    %% PROC
    % power
    pEEG = epochs_apply(@power_eeg, bEEG); 
    
    % ERD/ERS
    erdEEG = epochs_apply(@erd_ers, bEEG, [srate*5 srate*10] );
    erdEEG = epochs_apply(@window_func, erdEEG, srate, srate/2);
    
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