function [ config ] = setup( varargin )
%SETUP input: subjs, generate_SL and compute_results
%   Detailed explanation goes here
config = struct();
% Reload config vars with local_params.m script
if( ~exist( fullfile(pwd, 'local_params.m'), 'file') )
    error('Informe os parâmetros com o arquivo ''local_params.m''');
end
local_params;

params = utils.Var.argin2struct( varargin );

warning off;
config = utils.Var.catstruct(config, params);
warning on;

end

