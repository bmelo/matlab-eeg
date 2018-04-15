function [ out ] = group_matrix_eeg( config, nB )
%GROUP_MATRIX_EEG Summary of this function goes here
% Detailed explanation goes here

nSubjs = length(config.subjs);
srate = config.srate;
band = config.bands(nB,:);

% Extracting values
for k = 1:nSubjs
    subjN = config.subjs(k);
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir_in = fullfile( config.preproc_dir, subj );
    
    fname = gen_filename('cEEG', band, srate);
    EEG = eeg_load( subjdir_in, fname );
    
    EEG = laplacian_filter(EEG);
    EEG = epochs_apply(@erd_ers, EEG, [srate*5 srate*10] );
    % Validation
    if k == 1
        srate = EEG.srate;
        channels = {EEG.chanlocs(:).labels};
    elseif srate ~= EEG.srate
        error('Sample rate not matching!');
    end
    
    % Shrink only main part - not baselines
    EEG = epochs_shrink( EEG, 46*srate );
    
    % Removing bad channels
    p_ignore = find( [config.ignore{:,1}] == k );
    if p_ignore
        EEG = ignore_bad_channels( EEG, config.ignore{ p_ignore, 2 } );
    end
    
    out.data(k) = matrices(EEG);
    
    clear EEG;
end


out.srate = srate;
out.channels = channels;