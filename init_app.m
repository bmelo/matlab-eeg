% File to prepare application
% Initialize dependencies and do some setups

% Checking if need run file again
global included
if ~isempty(included) 
    return;
end

%% Loading configuration
try
    local_params
catch e
    config.vendors_dir = 'vendors';
end

%% Checking config.vendors_dir
[~, config.vendors_dir] = fileattrib( config.vendors_dir );
if ~( config.vendors_dir(1).directory )
    error(['config.vendors_dir = ' config.vendors_dir '\n Invalid directory.']);
else
    config.vendors_dir = config.vendors_dir(1).Name;
end

%% Including component matlab-utils
run( fullfile(config.vendors_dir, 'matlab-utils/libsetup.m'));

%% Primeiro os vendors, para poderem ser sobrescritos pela aplica��o
utils.path.includeSubdirs({
    'vendors/eeglab-14.1'
    'vendors/cosmomvpa'
    'vendors/bcilab'
    'vendors/arfit'
    'vendors/biosig/tsa/inst'
    'src'
});

%% Preparing eeglab
eeglab;

% Installing plugin to read Brain Vision signal
if( ~exist( 'pop_loadbv' ) )
	plugin_install('https://github.com/widmann/bva-io/archive/v1.5.14.zip', 'bva-io', '1.5.14');
	%Other important extensions:
	% SIFT
	% dipfit
	% firfilt
	eeglab;
end
close all;

% Preparing CoSMoMVPA
%cosmo_set_path;

included = 1;