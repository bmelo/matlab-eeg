rawdir = fullfile(config.rawdir_base, subj);
outdir = fullfile(config.outdir_base, subj);

%Checking result file
results_file = fullfile(outdir, 'results.mat');
if exist( results_file, 'file' )
    load( results_file );
    config.compute_results = ( config.compute_results && ...
        ~Msgs.confirm( sprintf('Sobrescrever arquivo %s ?', results_file)));
else
    config.compute_results = 1;
end

% downsample (500Hz) and separation of EEG channels and ECG, ACC
prepare_eeg_file;
epochs = epocas( EEG );
results.canais = {EEG.chanlocs.labels};
