function test_window( size, dir_out )
%TESTA_CANAIS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2, dir_out = 'WINDOWS'; end

%% Setup of processing
config = setup('neutral_length', 10);

config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/ROC';
config.cross.type = 'kfold';
config.cross.k = 8;
config.cross.repetitions = 10;

% Don't change - control of each channel
config.prefix = '';

size_secs = size;
win_dirname = sprintf('WIN_%d', size_secs * 1000);

config.window_size    = floor(config.srate * size_secs);
config.window_overlap = floor(config.window_size * .5);
if size ~= 1
    config.outdir_base    = fullfile(config.outdir_base, win_dirname);
end

% Executing according to config variable
accs = neural_network(config, false);
save(sprintf('%s/accs_chs_%s', dir_out, win_dirname), 'accs');

end
