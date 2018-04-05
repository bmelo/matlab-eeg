%% Checking if EEGLAB was started
if exist('eeglab','file')~=2
    %% Including component matlab-utils
    run( '../../vendors/matlab-utils/libsetup.m');
    
    %% First vendors to allow override with application functions
    utils.path.includeSubdirs({
        '../../vendors/eeglab-14.1'
        '../../src'
        });
    eeglab;
    close all;
end