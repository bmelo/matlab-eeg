function run_classification_channels()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

config.features = {'l_power_rel_feats' 'l_erders_feats'};
%config.features = {'eeg_feats'};
config.measures = {'median'};
config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/EEG';

config.bands = [8 13; 13 26];

config.cross.type = 'kfold';
config.cross.k = 8;
config.cross.repetitions = 5;

config.random_classes = 0;
config.show_window = 0;
config.max_fail = 10;

auxchs = load('channels');
auxchs = auxchs.channels;
config.subjs = 1:14;
config.subjs = [1 2 8 9];
for k=1:63
    config.prefix = sprintf('%02d_%s_', k, auxchs{k});
    
    config.channels = {
        [8 13],  {auxchs{k}}
        [13 26], {auxchs{k}}
        [26 45], {auxchs{k}}
    };
    
    neural_network(config);
end
%neural_network_intersubjs(config);


