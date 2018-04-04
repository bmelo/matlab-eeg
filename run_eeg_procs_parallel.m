function run_eeg_procs_parallel()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
init_app;
clc;

matlabpool open local 8
tempconf = setup('neutral_length', 10);
subjs = tempconf.subjs;

parfor k=1:length(tempconf.subjs)
    %% Setup of processing
    config = setup('neutral_length', 10);
    
    config.subjs = subjs(k);
    % Configuring Grand Average
    config.gavg_filter = @erd_ers;
    config.gavg_filter_params = {};
    
    % Executing according to config variable
    run_procs(config);
end

matlabpool close