function run_classification()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

config.subjs = [1 2 8 9];
config.outdir = 'STATS/CLASSIFICATION/ANN/FEATS';
config.prefix = '';

neural_network(config);
%neural_network_intersubjs(config);