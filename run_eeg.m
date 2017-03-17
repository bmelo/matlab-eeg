function run_eeg()
% Scripts to manipulate EEG data
%
% by Bruno Melo (bruno.raphael@gmail.com)

% Preparing components (eeglab, matlab-utils)
includeDeps;

%% Setup of processing
close all; clc;
config = setup('subjs', 7, 'neutral_length', 10);
chs = 46;
extra = 'before';

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
        cEEG = epochs_apply(@filter_bands, EEG, EEG.srate, [7 45]);
    end
    %plot_overlap_task(EEG, 'raw', chs, 0, extra);
    %plot_overlap_task(EEG, 'raw-mean', chs, 1, extra);
    %plot_overlap_task(cEEG, 'high-low filtered', chs, 1, extra);
    
    %% Characteristics
    % POWER
    %EEG_pow  = epochs_apply(@power_eeg, cEEG);
    %plot_overlap_task(EEG_pow, 'power', chs, 0, extra);

    % ERD/ERS
    EEG_erd = epochs_apply( @erd_ers, cEEG, cEEG.srate, floor(cEEG.srate/5) );
    plot_overlap_task(EEG_erd, 'ERD-ERS', chs, 0, extra);
    
    %% Processing
    if config.do_first_level
        %first_level;
    end
    
    %input('[Enter] para continuar...');
    fprintf('\n\n');
    close all;
end

%% Group processing
if( config.do_second_level )
    %second_level;
end