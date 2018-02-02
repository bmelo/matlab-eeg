%% Checking if EEGLAB was started
if ~evalin('base', 'exist(''eeglabUpdater'', ''var'')');
    %% Including component matlab-utils
    run( '../../vendors/matlab-utils/libsetup.m');
    
    %% Primeiro os vendors, para poderem ser sobrescritos pela aplica��o
    utils.path.includeSubdirs({
        '../../vendors/eeglab-14.1'
        '../../src'
        });
    eeglab;
    close all;
end