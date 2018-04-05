function testa_canais( nCH, dir_out )
%TESTA_CANAIS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2, dir_out = 'CHANNELS'; end

%% Setup of processing
    config = setup('neutral_length', 10);
    
    config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/ROC';
    config.cross.type = 'kfold';
    config.cross.k = 8;
    config.cross.repetitions = 10;
    
    auxchs = load('../../extra/channels');
    auxchs = auxchs.channels;
    
    % Don't change - control of each channel
    config.featselection = 1;
    config.prefix = '';
    config.channels = bands_channels_sel(config, auxchs(nCH));
    
    config.ann.featselection = 1;
    
    accs = neural_network(config, false);
    if length(nCH) > 1
        save(sprintf('%s/accs_chs_1-to-%02d', dir_out, length(nCH)), 'accs');
    else
        save(sprintf('%s/accs_chs_%02d', dir_out, nCH), 'accs');
    end

end