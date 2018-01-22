function run_eeg_procs()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
init_app;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

% Configuring Grand Average
config.gavg_filter = @erd_ers;
config.gavg_filter_params = {};

% Executing according to config variable
run_procs(config);
