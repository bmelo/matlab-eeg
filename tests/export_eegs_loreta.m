includeDeps;
config = setup('neutral_length', 10);

config.subjs = [1 2 4:14];
config.bands = [4 8; 8 13; 13 30; 30 45];
config.srate = 250;

for subjN = config.subjs
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir_in = fullfile( config.preproc_dir, subj );
    
    for nB = 1:length(config.bands)
        band = config.bands(nB, :);
        fname = gen_filename('cEEG', band, config.srate);
        EEG = eeg_load( subjdir_in, fname );
            
        % Laplacian filter
        %EEG = laplacian_filter(EEG);
        % Instead this, use CSP in BVA
        
        band = sprintf('%02d-%02d', EEG.ext.bands);
        outfile = [subj '_' band];
        export_eeg_BVA(EEG, outfile);
    end
end