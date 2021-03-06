% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

config.subjs = [1 2 4:14];
config.features = {'l_power_rel_feats' 'l_erders_feats'};
config.bands = [4 8; 8 13; 13 30; 30 45];
config.outdir = 'STATS/CLASSIFICATION/ANN/COMPLETE';
config.prefix = '';

accs = neural_network(config);
%neural_network_intersubjs(config);