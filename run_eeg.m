function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;
debug = 0;

%% Setup of processing
config = setup('neutral_length', 10);
if debug
    config.subjs = 8;
    config.chs = 1:63;
end

% Executing according to config variable
run_procs(config);
