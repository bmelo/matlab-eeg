% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)
curdir = pwd;
addpath(curdir);

% Preparing components (eeglab, matlab-utils)
cd ../..;
init_app;
clc;

%% Setup of processing
config = setup('neutral_length', 10);


% Overloading default values
%config.features = {'power_rel_feats' 'erders_feats'};
%config.features = {'l_eeg_feats'};
%config.measures = {'median'};
%config.bands = [4 8; 8 13; 13 30; 30 45];
%config.subjs = 1:14;
%config.subjs = [1 2 8 9];

config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/EEG-ROC';
config.cross.type = 'kfold';
config.cross.k = 8;
config.cross.repetitions = 10;

auxchs = load('extra/channels');
auxchs = auxchs.channels;

% Don't change - control of each channel
config.featselection = 1;
for k=1:63
    config.prefix = sprintf('%02d_%s_', k, auxchs{k});
    config.channels = bands_channels_sel(config, {auxchs{k}});
    
    accs = neural_network(config);
    save(sprintf('accs_all_%d-%d', config.bands), 'accs');
end

cd(curdir);

