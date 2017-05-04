function first_level(config)

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    fprintf('\n####   FIRST LEVEL - %s   ####\n\n', subj);
    
    outdir = fullfile( config.outdir_base, subj );
    if( ~isdir(outdir) )
        mkdir(outdir)
    end
    
    results = load_results(config, subj);
    if( isempty(results) )
        do_stats;
    end
    
    fprintf('\n\n');
    clear EEG AUX cEEG bEEG bEEG_erd;
end