function run_classification_channels()
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

%config.features = {'power_rel_feats' 'erders_feats'};
config.features = {'eeg_feats'};
config.measures = {'median' 'max' 'min' 'rms' 'std'};
config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/EEG';

config.cross.type = 'kfold';
config.cross.k = 16;
config.cross.repetitions = 5;

config.random_classes = 0;
config.show_window = 0;
config.max_fail = 10;

% For feature selection - don't change in this file!
config.featselection = 1;

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


