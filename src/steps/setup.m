function [ config ] = setup( varargin )
%SETUP input: subjs, generate_SL and compute_results
%   Detailed explanation goes here

% Defaults
config = struct(...
    'subj_prefix', 'SUBJ', ...
    'compute_results', 0, ...
    'do_preproc', 1, ...
    'do_first_level', 1, ....
    'do_second_level', 1 ...
);

% Reload config vars with local_params.m script
if( ~exist( fullfile(pwd, 'local_params.m'), 'file') )
    error('Informe os par�metros com o arquivo ''local_params.m''');
end
local_params;

params = utils.Var.argin2struct( varargin );
config = utils.Var.catstruct(config, params);

end

