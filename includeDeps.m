%run('vendors/matlab-utils/init.m');

% Primeiro os vendors, para poderem ser sobrescritos pela aplicação
utils.path.includeSubdirs({
    'vendors/eeglab'
    'vendors/cosmomvpa'
    'src'
});

% Preparing eeglab
if ~exist('eeglabUpdater', 'var')
    eeglab;
end
close all;

% Preparing CoSMoMVPA
%cosmo_set_path;
