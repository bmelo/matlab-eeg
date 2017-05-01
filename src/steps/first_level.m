outdir = fullfile( config.outdir_base, subj );
if( ~isdir(outdir) )
    mkdir(outdir)
end

results = load_results(config, subj);
if( isempty(results) )
    do_stats;
end