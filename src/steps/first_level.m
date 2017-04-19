outdir = fullfile( config.outdir_base, subj );
if( ~isdir(outdir) )
    mkdir(outdir)
end


if( ~load_results(config, subj) )
    do_stats;
end
results_SL.(subj) = results;

%do_report;
