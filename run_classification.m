% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
init_app;
clc;

%% Setup of processing
config = setup('neutral_length', 10);

%config.features = {'l_conn_gpdc'};
config.outdir = 'STATS/CLASSIFICATION/ANN';
config.prefix = '';

config.subjs = 4;
config.features = {'l_power_feats' 'l_power_rel_feats' 'l_dens_feats'};

accs = neural_network(config);
save('accs_all', 'accs');


% bands = config.bands;
% for nB = 1:size(bands, 1)
%     config.bands = bands(nB, :);
%     accs = neural_network(config);
%     save(sprintf('accs_all_%d-%d', config.bands), 'accs');
% end
% %neural_network_intersubjs(config);