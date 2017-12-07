function extract_features( config )
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes here

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir_in = fullfile( config.preproc_dir, subj );
    subjdir_out = fullfile( config.outdir_base, 'FEATS', subj );
    if ~isdir( subjdir_out )
        mkdir( subjdir_out )
    end
    
    srate = config.srate;
    
    fprintf('\n####   FEATURE EXTRACTION - %s   ####\n\n', subj);
    
    %% Spectral Density
    if config.proc.features.density
        EEG = eeg_load( subjdir_in, sprintf('cEEG_%d', srate) );
        % Laplacian filter
        EEG = laplacian_filter(EEG);
        
        for nB = 1:length(config.bands)
            densEEG(nB) = epochs_apply(@window_func, EEG, srate, srate/2, ...
                @spectral_density, srate, srate, [], config.bands(nB,:));
            band = config.bands(nB, :);
            eeg_save( subjdir_out, gen_filename('l_dens_feats', band), densEEG(nB) );
        end
        clear EEG;
    end
    
    %% Connectivity
    if config.proc.features.connectivity
        EEG = eeg_load( subjdir_in, sprintf('cEEG_%d', srate) );      

        [PDC, DTF] = pdc_dtf_eeg(EEG, srate);
        
        eeg_save( subjdir_out, 'l_pdc_feats', PDC );
        eeg_save( subjdir_out, 'l_dtf_feats', DTF );
        
        clear EEG;
    end
    
    % Separating each band
    feats = config.proc.features;
    if feats.erders || feats.power || feats.power_rel || feats.eeg
        for nB = 1:length(config.bands)
            band = config.bands(nB, :);
            fname = gen_filename('cEEG', band, srate);
            EEG = eeg_load( subjdir_in, fname );
            
            % Laplacian filter
            EEG = laplacian_filter(EEG);            
            
            overlap  = srate/2;
            %% Electrical activity (EEG)
            if feats.eeg
                EEGfeats = prepare_measures( EEG, srate, overlap );
                eeg_save( subjdir_out, gen_filename('l_eeg_feats', band), EEGfeats );
            end

            %% POWER
            if feats.power
                pEEG      = epochs_apply(@power_eeg, EEG);
                pEEGfeats = prepare_measures( pEEG, srate, overlap );
                eeg_save( subjdir_out, gen_filename('l_power_feats', band), pEEGfeats );
            end
            
            %% POWER
            if feats.power_rel
                pEEG      = epochs_apply(@power_rel_eeg, EEG);
                pEEGfeats = prepare_measures( pEEG, srate, overlap );
                eeg_save( subjdir_out, gen_filename('l_power_rel_feats', band), pEEGfeats );
            end

            %% ERD/ERS
            if feats.erders
                erdEEG      = epochs_apply(@erd_ers, EEG, [srate*5 srate*10] );
                erdEEGfeats = prepare_measures( erdEEG, srate, overlap );
                eeg_save( subjdir_out, gen_filename('l_erders_feats', band), erdEEGfeats );
            end
        end
    end
end

end

% Preparing features
function feature = prepare_measures( EEG, srate, overlap )

feature.median = epochs_apply(@window_func, EEG, srate, overlap);
feature.mean   = epochs_apply(@window_func, EEG, srate, overlap, @mean);
feature.rms    = epochs_apply(@window_func, EEG, srate, overlap, @utils.math.rms);
feature.max    = epochs_apply(@window_func, EEG, srate, overlap, @max);
feature.min    = epochs_apply(@window_func, EEG, srate, overlap, @min);
feature.std    = epochs_apply(@window_func, EEG, srate, overlap, @std);

end