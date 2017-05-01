function run_SL()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;
debug = 0;

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
        % Loading EEG/AUX - downsample to 500Hz
        [EEG, AUX] = prepare_eeg(config, subj, 500);
        clear AUX;
        
        % removing some channels
        EEG = pop_select( EEG, 'channel', config.chs);
        chs_new = 1:length(config.chs);
        
        EEG.ext.epochs = epocas_v2( EEG );
        
        % Manipulating signal
        EEG = epochs_match_all(EEG);
        cEEG = epochs_apply(@filter_bands, EEG, EEG.srate, [7 45]);
        %bEEG = break_bands(EEG, config.bands);
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