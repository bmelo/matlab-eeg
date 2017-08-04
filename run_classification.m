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

config.patts = {'power_feats'};
config.features = {'median'};

config.cross.type = 'montecarlo';
config.cross.k = 4; % used in monte carlo
config.cross.repetitions = 100;

% For feature selection
config.channels = {
    [8 13],  {'F3' 'F4' 'C3' 'C4' 'P3' 'P4' 'O1' 'O2' 'F7' 'F8' 'T7' 'T8' 'P7' 'P8' 'Fz' 'Cz' 'Pz' 'Oz' 'FC1' 'FC2' 'CP1' 'CP2' 'FC5' 'FC6' 'CP5' 'CP6' 'TP9' 'TP10' 'POz' 'F1' 'F2' 'C1' 'C2' 'P1' 'P2' 'AF3' 'AF4' 'FC3' 'FC4' 'CP3' 'CP4' 'PO3' 'PO4' 'F5' 'F6' 'C5' 'C6' 'P5' 'P6' 'FT7' 'FT8' 'TP7' 'TP8' 'PO7' 'PO8' 'FT9' 'FT10' 'CPz'}
    [13 26], {'P3' 'O1' 'O2' 'T7' 'T8' 'P7' 'P8' 'Pz' 'Oz' 'TP9' 'POz' 'P1' 'PO3' 'PO4' 'P5' 'P6' 'TP7' 'TP8' 'PO7' 'PO8' 'FT9' 'CPz'}
    [26 45], {'FT9' 'FT10'}
};
config.featselection = 0;

neural_network(config);
%neural_network_intersubjs(config);