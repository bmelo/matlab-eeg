function acc = fitness_function( ga_ind )
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

%% Setup of processing
config = setup('neutral_length', 10);

config.features = {'l_power_rel_feats' 'l_erders_feats'};
%config.features = {'l_eeg_feats'};
config.measures = {'median'};
config.outdir = 'STATS/CLASSIFICATION/GA';
config.prefix = '';

ga_file = fullfile(config.outdir_base, config.outdir, [sprintf('%d', ga_ind) '.txt']);
if exist(ga_file, 'file')
    acc = 1 - dlmread( ga_file );
    return;
end

config.bands = [8 13; 13 26];

config.cross.type = 'kfold';
config.cross.k = 8;
config.cross.repetitions = 2;

config.subjs = 1:14;
%config.subjs = [1 2 8 9];

% Don't change - control of each channel
config.featselection = 1;
auxchs = load('extra/channels');
auxchs = auxchs.channels( ga_ind == 1 );

config.channels = {
    [8 13],  auxchs
    [13 26], auxchs
    };

accs = neural_network(config, false);

acc = mean( median(accs, 2) );

utils.file.txt_write(ga_file, sprintf('%.4f', acc), 0, 1 );

% MATLAB GA tries to minimize the results. Work with error!!
acc = 1-acc;


