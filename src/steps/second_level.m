function second_level(config)

% Do the same for each subject
for subjN = config.subjs
    
    
    
    results = results_SL;
    out_file = fullfile(config.outdir_base, 'results_all.mat');
    save( out_file, 'results' );
end