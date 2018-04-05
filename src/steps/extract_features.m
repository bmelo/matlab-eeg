function extract_features( config )
%EXTRACT_FEATURES Summary of this function goes here
%   Detailed explanation goes here

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    config.subj = subjN;
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir_in = fullfile( config.preproc_dir, subj );
    subjdir_out = fullfile( config.outdir_base, 'FEATS', subj );
    if ~isdir( subjdir_out )
        mkdir( subjdir_out )
    end
    
    srate = config.srate;
    w_size = utils.Var.get(config, 'window_size', config.srate);
    w_overlap = utils.Var.get(config, 'window_overlap', w_size * .5);
    
    fprintf('\n####   FEATURE EXTRACTION - %s   ####\n\n', subj);
    
    %% Spectral Density
    if config.proc.features.density
        EEG = eeg_load( subjdir_in, sprintf('cEEG_%d', srate) );
        % Laplacian filter
        EEG = laplacian_filter(EEG);
        
        for nB = 1:size(config.bands,1)
            densEEG(nB) = epochs_apply(@window_func, EEG, w_size, w_overlap, ...
                @spectral_density, srate, w_size, [], config.bands(nB,:));
            band = config.bands(nB, :);
            eeg_save( subjdir_out, gen_filename('l_dens_feats', band), densEEG(nB) );
        end
        clear EEG;
    end
    
    %% Connectivity
    if config.proc.features.connectivity
        EEG = eeg_load( subjdir_in, sprintf('cEEG_%d', srate) );
        
        gpdc_eeg(EEG, config);
        
        % Generating output for each band
        tmpfile = utils.resolve_name( fullfile(subjdir_out, 'l_conn_gpdc*') );
        connEEG = load( tmpfile ); % Carrega todos os dados em CONN
        
        for nB = 1:size(config.bands,1)
            band = config.bands(nB,:);
            for cond = {'T' 'A' 'N'}
                connBand = connEEG.EEG.(cond{1})(:,:,band(1):band(2),:);
                conn.(cond{1}) = squeeze( utils.math.rms(connBand, 3) );
            end
            
            eeg_save( subjdir_out, gen_filename('l_conn_gpdc', band), conn );
            clear conn connBand;
        end
        
        clear EEG connEEG;
    end
    
    % Separating each band
    feats = config.proc.features;
    
    %% RELATIVE POWER
    if feats.power_rel
        % Needs global power
        fname = gen_filename('cEEG', config.band_global, srate);
        EEG = eeg_load( subjdir_in, fname );
        EEG = laplacian_filter(EEG);
        pEEG_global = epochs_apply(@power_eeg, EEG);
    end
    
    if feats.power_rel || feats.erders || feats.power || feats.eeg
        % Working on each band
        for nB = 1:length(config.bands)
            band = config.bands(nB, :);
            fname = gen_filename('cEEG', band, srate);
            EEG = eeg_load( subjdir_in, fname );
            
            % Laplacian filter
            EEG = laplacian_filter(EEG);
            
            %% RELATIVE POWER
            if feats.power_rel 
                pEEG      = epochs_apply2(@power_rel_eeg, EEG, pEEG_global);
                pEEGfeats = prepare_measures( pEEG, w_size, w_overlap );
                eeg_save( subjdir_out, gen_filename('l_power_rel_feats', band), pEEGfeats );
            end
            
            %% Electrical activity (EEG)
            if feats.eeg
                EEGfeats = prepare_measures( EEG, w_size, w_overlap );
                eeg_save( subjdir_out, gen_filename('l_eeg_feats', band), EEGfeats );
            end
            
            %% POWER
            if feats.power
                pEEG      = epochs_apply(@power_eeg, EEG);
                pEEGfeats = prepare_measures( pEEG, w_size, w_overlap );
                eeg_save( subjdir_out, gen_filename('l_power_feats', band), pEEGfeats );
            end
            
            %% ERD/ERS
            if feats.erders
                erdEEG      = epochs_apply(@erd_ers, EEG, [srate*5 srate*10] );
                erdEEGfeats = prepare_measures( erdEEG, w_size, w_overlap );
                eeg_save( subjdir_out, gen_filename('l_erders_feats', band), erdEEGfeats );
            end
        end
    end
end

end

% Preparing features
function feature = prepare_measures( EEG, w_size, w_overlap )

feature.median = epochs_apply(@window_func, EEG, w_size, w_overlap);
% feature.mean   = epochs_apply(@window_func, EEG, w_size, w_overlap, @mean);
% feature.rms    = epochs_apply(@window_func, EEG, w_size, w_overlap, @utils.math.rms);
% feature.max    = epochs_apply(@window_func, EEG, w_size, w_overlap, @max);
% feature.min    = epochs_apply(@window_func, EEG, w_size, w_overlap, @min);
% feature.std    = epochs_apply(@window_func, EEG, srate, overlap, @std);

end