function first_level(config)

% Do the same for each subject
pool = parpool(14);
subjs = config.subjs;
parfor nS = 1:length(subjs)
    close all;
    do_first_level(config, subjs(nS));
end
delete(pool);


% Function created to enable parallel processing
function do_first_level( config, subjN )

srate = config.srate;

subj = sprintf('%s%03d', config.subj_prefix, subjN);
fprintf('\n####   FIRST LEVEL - %s   ####\n\n', subj);
subjdir_in = fullfile( config.preproc_dir, subj );
subjdir_out = fullfile( config.outdir_base, subj );

if( ~isdir(subjdir_out) )
    mkdir(subjdir_out)
end

for nB = 1:size(config.bands,1)
    band = config.bands(nB,:);
    sBand = sprintf('%d-%d', band);
    fname = gen_filename('cEEG', band, srate);
    EEG = eeg_load( subjdir_in, fname );
    
    % Laplacian filter
    EEG = laplacian_filter(EEG);
    erdEEG = epochs_apply(@erd_ers, EEG, [srate*5 srate*10] );
    erdEEG.data = matrices(erdEEG);
    erdEEG = rmfield(erdEEG, 'ext');
    
    results = load_results(config, subj);
    if isempty(results) || 1
        disp('Computing ...');
        
        %% Going through all bands
        %results.stats.bands.erders  = testConds( erdEEG, 'testF' );
        results.stats.bands(nB).erders  = testConds( erdEEG, 'friedman' );
        results.channels = {erdEEG.chanlocs(:).labels};
        clear EEG erdEEG;
        
        % Saving
        %results_file = fullfile( subjdir_out, 'results.mat' );
        %save( results_file, 'results' );
    end
    
    fprintf('\n\n[%s] ERD/ERS [%s]\n', subj, sBand);
    print_report( results.stats.bands(nB).erders.median, results.channels );
    fprintf('\n\n');
    clear EEG AUX cEEG bEEG bEEG_erd;
end