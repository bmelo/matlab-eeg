function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;

import utils.Msgs;

%% Setup of processing
close all; clc;
config = setup('subjs', 1:14);

% Do the same for each subject
for subjN = config.subjs
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    fprintf('\n####    %s   ####\n\n', subj);
    
    %% Preproc
    if config.do_preproc
        % Loading EEG/AUX - downsample to 500Hz
        [EEG, AUX] = prepare_eeg(config, subj, 500);
        EEG.ext.epochs = epocas_v2( EEG );
        
        % Manipulating signal
        EEG = epochs_match_all(EEG);
        EEG = epochs_apply(EEG, @filter_bands, EEG.srate, [7 45]);
    end
    
    %% Characteristics
    EEG_pw = epochs_apply(EEG, @power_eeg);
    %EEG_en = entropy(epochs)
    %EEG_pw = power(epochs)
    
    %% Visual Check
    %plot_eeg(EEG);
    %plot_cond(EEG);
    % std(epochs);
    plot_overlap_task(EEG_pw, 1:63, 'power');
    
    %% Processing
    if config.do_first_level
        %first_level;
    end
    
    %input('[Enter] para continuar...');
    clear EEG results;
    disp('');
end

%% Group processing
if( config.do_second_level )
    %second_level;
end