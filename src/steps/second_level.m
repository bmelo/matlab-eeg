results = results_SL;
out_file = fullfile(config.outdir_base, 'results_all.mat');
save( out_file, 'results' );