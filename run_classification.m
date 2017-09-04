function run_classification()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

config.subjs = 1:14;
config.features = {'l_power_rel_feats' 'l_erders_feats'};
config.bands = [8 13; 13 26];
config.outdir = 'STATS/CLASSIFICATION/ANN/FEATS-LAPLACE-ALPHA+BETA';
config.prefix = '';

neural_network(config);
%neural_network_intersubjs(config);