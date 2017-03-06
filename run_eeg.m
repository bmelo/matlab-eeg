function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;

import utils.Msgs;

%% Setup of processing
close all; clc;
config = setup('subjs', 8);

% Do the same for each subject
for subjN = config.subjs
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    fprintf('\n####    %s   ####\n\n\n', subj);
    
    %% Preproc
    if config.do_preproc
        %extract_matrix -> Epochs
        load_data;
        
        % Manipulating signal
        epochs = match_length_all(epochs);
        epochs = filter_bands(epochs, [7 45]);
    end
    
    %% Characteristics
    epochsSD = sync_desync(epochs);
    
    %% Visual Check
    %plot_eeg(EEG);
    %plot_cond(EEG);
    % std(epochs);
    plot_overlap_task(epochsSD);
    
    %% Processing
    if config.do_first_level
        %first_level;
    end
    
    %input('[Enter] para continuar...');
    clear EEG results;
end

%% Group processing
if( config.do_second_level )
    %second_level;
end