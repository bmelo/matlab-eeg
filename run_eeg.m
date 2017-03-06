function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

import utils.Msgs;

% Preparing components (eeglab, matlab-utils)
includeDeps;

%% Setup of processing
config = setup('subjs', 8);
clear results_SL;

close all;
for subjN = config.subjs
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    fprintf('\n\n\n####    %s   ####\n', subj);
    
    %% Preproc
    if config.do.preproc
        %extract_matrix -> Epochs
        load_data;
        
        % Manipulating signal
        epochs = match_length_all(epochs);
        epochs = filter_bands(epochs, [7 45]);
        epochsSD = sync_desync(epochs);
    end
    
    %% Visual Check
    %plot_eeg(EEG);
    %plot_cond(EEG);
    % std(epochs);
    plot_overlap_task(epochsSD);
    
    %% Processing
    if config.do.first_level
        %first_level;
    end
    
    %input('[Enter] para continuar...');
    clear EEG results;
end

%% Group processing
if( config.do.second_level )
    %second_level;
end