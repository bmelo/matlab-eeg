% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
init_app;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

config.bands = [13 26; 26 45];
config.outdir = 'STATS/CLASSIFICATION/ANN/PDC';
config.prefix = '';

bands = config.bands;
for nB = 1:size(bands, 1)
    config.bands = bands(nB, :);
    accs = neural_network(config);
    save(sprintf('accs_%d-%d', config.bands), 'accs');
end
%neural_network_intersubjs(config);