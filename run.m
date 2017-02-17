%%% by Bruno Melo (bruno.raphael@gmail.com)
if( ~exist('CURRENTSET', 'var') )
    includeDeps;
end

% Default parameters
rawdir_base = '../data/';
outdir_base = rawdir_base;
subj_prefix = 'SUBJ';

% Reload config vars with local_params.m script
if( exist('local_params.m', 'file') )
    local_params;
end
generate_SL = 0;
results_SL = [];

% Execute
clc;
subjs = [1:6];
for subjN = subjs
    subj = sprintf('%s%03d', subj_prefix, subjN);
    rawdir = fullfile(rawdir_base, subj);
    outdir = fullfile(outdir_base, subj);
    
    %Checking result file
    results_file = fullfile(outdir, 'results.mat');
    compute_results = 1;
    if( exist( results_file, 'file' ) && ~Msgs.confirm( sprintf('Sobrescrever arquivo %s ?', results_file)) )
        load( results_file );
        compute_results = 0;
    end
    
    fprintf('\n\n\n\n\n####    %s   ####\n', subj);
    prepare_eeg_file;
    continue;
    
    %pop_eegplot( EEG, 1, 1, 1);
    eegplot( EEG, 'title', 'CANAIS EEG' );
    eegplot( AUX, 'title', 'AUXILIARES' );
    epochs = epocas( EEG );
    results.canais = {EEG.chanlocs.labels};
    
    if( compute_results )
        disp('Computing ...');
        results.stats.bands = testBands( epochs );
        results.stats.conds = testConds( epochs );
        results.stats.condsJoin = testCondsJoin( epochs );
        results.stats.condsJoinRuns = testCondsJoinRuns( epochs );
        save( results_file, 'results' );
        generate_SL = 1;
    end
    results_SL.(subj) = results;
    
    cEEG.printReport( results.(subj).stats.bands, '\n\n-- Bands --', 2, [3 5] );
    cEEG.printReport( results.(subj).stats.conds, '\n\n-- Conds --', 1, [2 3] );
    cEEG.printReport( results.(subj).stats.condsJoin, '\n\n-- CondsJoin --', 1, [1 2] );
    cEEG.printReport( results.(subj).stats.condsJoinRuns, '\n\n-- CondsJoinRUNs --', 2, [1 1] );
    
    clear EEG results;
end

results = results_SL;
if( generate_SL )
    save( fullfile(outdir, 'results.mat'), 'results' );
end