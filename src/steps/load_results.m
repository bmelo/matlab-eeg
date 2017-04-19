function jump_stats = load_results(config, subj)

%Checking result file
results_file = fullfile( config.outdir_base, subj, 'results.mat' );
if exist( results_file, 'file' )
    load( results_file );
    config.compute_results = ( config.compute_results && ...
        utils.Msgs.confirm( sprintf('Sobrescrever arquivo %s ?', results_file)));
else
    config.compute_results = 1;
end

jump_stats = ~config.compute_results;