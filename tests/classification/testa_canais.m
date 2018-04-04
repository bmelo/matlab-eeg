function testa_canais( nCH )
%TESTA_CANAIS Summary of this function goes here
%   Detailed explanation goes here
%% Setup of processing
    config = setup('neutral_length', 10);
    
    config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/ROC';
    config.cross.type = 'kfold';
    config.cross.k = 8;
    config.cross.repetitions = 10;
    
    auxchs = load('extra/channels');
    auxchs = auxchs.channels;
    
    % Don't change - control of each channel
    config.featselection = 1;
    config.prefix = '';
    config.channels = bands_channels_sel(config, auxchs(nCH));
    
    accs = neural_network(config);
    if length(nCH) > 1
        save(sprintf('accs_chs_num-%02d', length(nCH)), 'accs');
    else
        save(sprintf('accs_chs_%02d', nCH), 'accs');
    end

end

