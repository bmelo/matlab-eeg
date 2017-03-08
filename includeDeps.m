global included
if ~isempty(included)
    return;
end

%% Including component matlab-utils
mdir = fileparts(mfilename('fullpath'));
run( fullfile(mdir, 'vendors/matlab-utils/init.m'));

%% Primeiro os vendors, para poderem ser sobrescritos pela aplica��o
utils.path.includeSubdirs({
    'vendors/eeglab'
    'vendors/cosmomvpa'
    'src'
});

%% Preparing eeglab
if ~exist('eeglabUpdater', 'var')
    eeglab;
    
    % Installing plugin to read Brain Vision signal
    if( ~exist( 'pop_loadbv' ) )
        plugin_install('https://github.com/widmann/bva-io/archive/v1.5.14.zip', 'bva-io', '1.5.14');
        eeglab;
    end
end
close all;

% Preparing CoSMoMVPA
%cosmo_set_path;

included = 1;