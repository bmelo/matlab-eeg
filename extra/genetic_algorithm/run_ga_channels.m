function run_ga_channels()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

config.features = {'l_power_rel_feats' 'l_erders_feats'};
%config.features = {'l_eeg_feats'};
config.measures = {'median'};
config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/EEG';

config.bands = [8 13; 13 26];

config.cross.type = 'kfold';
config.cross.k = 8;
config.cross.repetitions = 10;

auxchs = load('extra/channels');
auxchs = auxchs.channels;
config.subjs = 1:14;
config.subjs = [1 2 8 9];

% Don't change - control of each channel
config.featselection = 1;
for k=1:63
    config.prefix = sprintf('%02d_%s_', k, auxchs{k});
    
    config.channels = {
        [8 13],  {auxchs{k}}
        [13 26], {auxchs{k}}
    };
    
    neural_network(config);
end


