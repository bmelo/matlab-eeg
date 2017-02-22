function run()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)
%
includeDeps;

global epochs;

% Default parameters
rawdir_base = '/media/lapis/HD Trabalhos/EEG/raw_data/';
outdir_base = '/media/lapis/HD Trabalhos/EEG/PROC_DATA/';
subj_prefix = 'SUBJ';

% Reload config vars with local_params.m script
if( exist('local_params.m', 'file') )
%    local_params;
end
generate_SL = 0;
results_SL = [];

% Execute
clc;
subjs = 7;
compute_results = 0;
for subjN = subjs
    close all;
    subj = sprintf('%s%03d', subj_prefix, subjN);
    rawdir = fullfile(rawdir_base, subj);
    outdir = fullfile(outdir_base, subj);
    
    %Checking result file
    results_file = fullfile(outdir, 'results.mat');
    if exist( results_file, 'file' )
        load( results_file );
        compute_results = ( compute_results && ...
            ~Msgs.confirm( sprintf('Sobrescrever arquivo %s ?', results_file)));
    else
        compute_results = 1;
    end
    
    
    fprintf('\n\n\n####    %s   ####\n', subj);
    
    % downsample (500Hz) and separation of EEG channels and ECG, ACC
    prepare_eeg_file;
    epochs = epocas( EEG );
    results.canais = {EEG.chanlocs.labels};
    
    % artifacts remotion
    artifact_remotion(epochs);
    print(gcf,fullfile( outdir, 'std_ch_F5.png' ),'-dpng')
    
    % Channels to check: (Fp1, Fp2, F5, F6) - 1,2,46,47
    
    
    %pop_eegplot( EEG, 1, 1, 1);
    %eegplot( EEG, 'title', 'CANAIS EEG' );
    %eegplot( AUX, 'title', 'AUXILIARES' );
    
    if( compute_results ); do_stats; end;
    results_SL.(subj) = results;
    
    %do_report;
    
    input('[Enter] para continuar...');
    clear EEG results;
end

if( generate_SL )
    results = results_SL;
    save( fullfile(outdir_base, 'results_all.mat'), 'results' );
end