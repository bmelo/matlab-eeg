function prepare_windows()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
addpath( fileparts( fileparts( pwd ) ) );
init_app;
clc;

%% Setup of processing
parpool open local 12
tempconf = setup('neutral_length', 10);
subjs = tempconf.subjs;

cd ../..;

parfor nSubj=1:length(subjs)
    config = setup('neutral_length', 10);
    
    config.subjs = subjs(nSubj);
    
    config.preproc.active = 0;
    config.proc.features.active = 1;
    config.proc.features.erders = 1;
    config.proc.features.power = 1;
    config.proc.features.power_rel = 1;
    config.proc.features.eeg = 0;
    config.proc.features.density = 1;
    
    preproc_dir = config.preproc_dir;
    outdir_base = config.outdir_base;
    
    % 1 second removed - was the default value
    for size = [.5 1 1.5 2 3 4]
        size_secs = size;
        win_dirname = sprintf('WIN_%d', size_secs * 1000);
        
        config.window_size    = floor(config.srate * size_secs);
        config.window_overlap = floor(config.window_size * .5);
        config.preproc_dir    = fullfile(preproc_dir, win_dirname);
        config.outdir_base    = fullfile(outdir_base, win_dirname);
        
        % Executing according to config variable
        run_procs(config);
    end
end

matlabpool close