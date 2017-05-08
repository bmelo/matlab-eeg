function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;
debug = 1;

%% Setup of processing
config = setup('neutral_length', 10);
if debug
    config.subjs = 1;
    config.chs = 1:2;
end

% Configuring Grand Average
config.gavg_files = {'pEEG_global'};
config.gavg_filter = @erd_ers;
config.gavg_filter_params = {};

% Executing according to config variable
run_procs(config);
