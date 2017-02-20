function run()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)
%

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
subjs = 1:14;
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
    
    fprintf('\n\n\n####    %s   ####\n', subj);
    
    % downsample (500Hz) and separation of EEG channels and ECG, ACC
    prepare_eeg_file;
    epochs = epocas( EEG );
    results.canais = {EEG.chanlocs.labels};
    
    % artifacts remotion
    artifact_remotion;
    
    %pop_eegplot( EEG, 1, 1, 1);
    eegplot( EEG, 'title', 'CANAIS EEG' );
    eegplot( AUX, 'title', 'AUXILIARES' );
    
    if( compute_results ); do_stats; end;
    results_SL.(subj) = results;
    
    do_report;
    
    clear EEG results;
end

results = results_SL;
if( generate_SL )
    save( fullfile(outdir, 'results.mat'), 'results' );
end