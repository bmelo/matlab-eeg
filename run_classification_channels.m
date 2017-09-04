function run_classification_channels()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

config.features = {'power_rel_feats' 'erders_feats'};
%config.features = {'l_eeg_feats'};
config.measures = {'median'};
config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/EEG-prev';

config.bands = [8 13; 13 26];

config.cross.type = 'kfold';
config.cross.k = 8;
config.cross.repetitions = 5;

auxchs = load('extra/channels');
auxchs = auxchs.channels;
config.subjs = 1:14;
config.subjs = [1 2 8 9];
for k=1:63
    config.prefix = sprintf('%02d_%s_', k, auxchs{k});
    
    config.channels = {
        [8 13],  {auxchs{k}}
        [13 26], {auxchs{k}}
    };
    
    neural_network(config);
end
%neural_network_intersubjs(config);


