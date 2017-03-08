if( ~isdir(outdir) )
    mkdir(outdir)
end

load_results(config);

if( config.compute_results ); do_stats; end;
results_SL.(subj) = results;

%do_report;
