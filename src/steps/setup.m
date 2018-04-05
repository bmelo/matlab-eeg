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
if( ~exist( 'local_params.m', 'file') )
    error('File ''local_params.m'' not found.');
end
local_params;

params = utils.Var.argin2struct( varargin );
config = utils.Var.catstruct(config, params);

end

