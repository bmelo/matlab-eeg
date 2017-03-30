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
only_before = 0;
%bands = [8 10; 10 13; 13 20; 20 26; 26 30; 30 45];
bands = [8 13; 13 26; 26 45];

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
        bEEG = break_bands(EEG, bands);
    end
    %plot_overlap_task(EEG, 'raw', chs, 0, only_before);
    %plot_overlap_task(EEG, 'raw-mean', chs, 1, only_before);
    %plot_overlap_task(cEEG, 'high-low filtered', chs, 1, only_before);
    
    %% Characteristics
    % POWER
    EEG_pow  = epochs_apply(@power_eeg, cEEG);
    plot_overlap_task(EEG_pow, 'power', chs, 0, only_before, @erd_ers, EEG.srate, floor(EEG.srate/5));

    % ERD/ERS
    %EEG_erd = epochs_apply( @erd_ers, EEG, EEG.srate, floor(EEG.srate/5) );
    %plot_overlap_task(EEG_erd, 'ERD-ERS', chs, 0, extra);
    bEEG_erd = epochs_apply( @power_eeg, bEEG );
    plot_bands_overlap_task(bEEG_erd, 'ERD-ERS', chs, 0, only_before, @erd_ers, bEEG(1).srate, floor(bEEG(1).srate/5));
    
    %% Processing
    if config.do_first_level
        %first_level;
    end
    
    %input('[Enter] para continuar...');
    fprintf('\n\n');
    %close all;
end

%% Group processing
if( config.do_second_level )
    %second_level;
end