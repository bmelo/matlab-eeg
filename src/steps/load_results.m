function results = load_results(config, subj)

%Checking result file
results_file = fullfile( config.outdir_base, subj, 'results.mat' );
if exist( results_file, 'file' )
    load( results_file, 'results' );
    if ~utils.Var.get(config, 'force', 1)
        config.compute_results = ( config.compute_results && ...
            utils.Msgs.confirm( sprintf('Sobrescrever arquivo %s ?', results_file)));
    end
else
    config.compute_results = 1;
end

%% Informing that need to be computed
if config.compute_results
    results = [];
end