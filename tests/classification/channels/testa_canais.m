function testa_canais( nCH, dir_out, label )
%TESTA_CANAIS Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2, dir_out = 'CHANNELS'; end
if nargin < 3
    if length(nCH) > 1
        label = sprintf('1-to-%02d', length(nCH));
    else
        label = sprintf('%02d', nCH);
    end
end

%% Setup of processing
    config = setup('neutral_length', 10);
    
    config.outdir = 'STATS/CLASSIFICATION/ANN/CHANNELS/ROC';
    config.cross.type = 'kfold';
    config.cross.k = 8;
    config.cross.repetitions = 10;
    
    auxchs = load('../../../extra/channels');
    auxchs = auxchs.channels;
    
    % Don't change - control of each channel
    config.featselection = 1;
    config.prefix = '';
    if iscell( nCH )
        chs = nCH;
    else
        chs = auxchs(nCH);
    end
    config.channels = bands_channels_sel(config, chs);
    
    config.ann.featselection = 1;
    
    accs = neural_network(config, false);
    save(sprintf('%s/accs_chs_%s', dir_out, label), 'accs');

end