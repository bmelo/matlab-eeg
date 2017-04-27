function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;
clc;

%% Setup of processing
config = setup('subjs', 1:14, 'neutral_length', 10);
chs = 1:63;
%config.subjs = 7;
%bands = [8 10; 10 13; 13 20; 20 26; 26 30; 30 45];
bands = [8 13; 13 26; 26 45];

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    fprintf('\n####    %s   ####\n\n', subj);
    
    %% Preproc
    if config.do_preproc
        % Loading EEG/AUX - downsample to 500Hz
        [EEG, AUX] = prepare_eeg(config, subj, 500);
        % removing some channels
        EEG = pop_select( EEG, 'channel', chs);
        chs_new = 1:length(chs);
        
        EEG.ext.epochs = epocas_v2( EEG );
        
        % Manipulating signal
        EEG = epochs_match_all(EEG);
        cEEG = epochs_apply(@filter_bands, EEG, EEG.srate, [7 45]);
        %bEEG = break_bands(EEG, bands);
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