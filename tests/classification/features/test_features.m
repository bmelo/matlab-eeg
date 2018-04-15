function test_features( features )
%TESTA_CANAIS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2, dir_out = 'FEATURES'; end

%% Setup of processing
config = setup('neutral_length', 10);

config.features = features;

config.outdir = 'STATS/CLASSIFICATION/ANN/FEATURES';
config.cross.type = 'kfold';
config.cross.k = 8;
config.cross.repetitions = 10;

% Don't change - control of each channel
config.prefix = '';

% Executing according to config variable
accs = neural_network(config, false);
str_feats = strjoin(features, '-');
save(sprintf('%s/accs_feature_%s', dir_out, str_feats), 'accs');

end
