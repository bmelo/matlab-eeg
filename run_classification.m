function run_classification()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

config.ignore = {
    1,  [48]
    2,  [18 48]
    3,  [49]
    4,  [9 10 20 31 44 45 54 59]
    5,  [31 34]
    6,  [32 41 63]
    9,  [48]
    10, [13 59]
    13, [27]
    14, [29 56]
};

%neural_network(config);
neural_network_intersubjs(config);