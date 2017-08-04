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
    
    %% Spectral Density
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
    if ~config.debug
        bEEG = epochs_apply(@remove_outliers, bEEG, srate, srate*.5);
        bEEG = epochs_apply(@remove_outliers, bEEG, srate, srate*.5);
    end
    
    % Separating each band
    for nB = 1:length(config.bands)
        band = config.bands(nB, :);
        
        %% Electrical activity (EEG)
        overlap  = srate/2;
        EEGfeats = prepare_features( bEEG(nB), srate, overlap );
        eeg_save( subjdir, gen_filename('eeg_feats', band), EEGfeats );
        
        %% POWER
        pEEG      = epochs_apply(@power_eeg, bEEG(nB));
        pEEGfeats = prepare_features( pEEG, srate, overlap );
        eeg_save( subjdir, gen_filename('power_feats', band), pEEGfeats );
        
        %% ERD/ERS
        erdEEG      = epochs_apply(@erd_ers, bEEG, [srate*5 srate*10] );
        erdEEGfeats = prepare_features( erdEEG, srate, overlap );
        eeg_save( subjdir, gen_filename('erders_feats', band), erdEEGfeats );
    end
    
    fprintf('\n\n');
    clear EEG AUX cEEG bEEG bEEG_erd;
end

end

% Preparing features
function feats = prepare_features( EEG, srate, overlap )

feats.median = epochs_apply(@window_func, EEG, srate, overlap);
feats.mean   = epochs_apply(@window_func, EEG, srate, overlap, @mean);
feats.rms    = epochs_apply(@window_func, EEG, srate, overlap, @utils.math.rms);
feats.max    = epochs_apply(@window_func, EEG, srate, overlap, @max);
feats.min    = epochs_apply(@window_func, EEG, srate, overlap, @min);
feats.std    = epochs_apply(@window_func, EEG, srate, overlap, @std);

end