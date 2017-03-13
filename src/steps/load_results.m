function load_results(config)

%Checking result file
results_file = fullfile( outdir, 'results.mat' );
if exist( results_file, 'file' )
    load( results_file );
    config.compute_results = ( config.compute_results && ...
        ~Msgs.confirm( sprintf('Sobrescrever arquivo %s ?', results_file)));
else
    config.compute_results = 1;
end
