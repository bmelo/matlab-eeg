%% Checking if EEGLAB was started
if exist('eeglab','file')~=2
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