function run_report()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('neutral_length', 10);
config.compute_results = 0;

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    fprintf('\n####    %s   ####\n\n', subj);
    
    %% Processing
    if config.do_first_level
        first_level;
    end
    do_report;
    
    fprintf('\n\n');
    results_SL.(subj) = results;
end