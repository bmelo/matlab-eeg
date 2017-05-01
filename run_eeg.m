function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;
debug = 1;

%% Setup of processing
config = setup('neutral_length', 10);
if debug
    config.subjs = 8;
    config.chs = 1:63;
end

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    fprintf('\n####    %s   ####\n\n', subj);
    
    %% Preproc
    if config.do_preproc
        preproc;
    end
    
    %% Visual Check
    if config.do_visual_check
        visual_check;
    end
    
    %% Processing
    if config.do_first_level
        first_level;
    end
    
    %input('[Enter] para continuar...');
    fprintf('\n\n');
    clear EEG AUX cEEG bEEG bEEG_erd;
end

%% Group processing
if( config.do_second_level )
    second_level;
end