function visual_check(config)

only_before = utils.Var.get(config, 'only_before', 0);

% Do the same for each subject
for subjN = config.subjs
    close all;
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.outdir_base, subj );
    
    fprintf('\n####   VISUAL CHECK - %s   ####\n\n', subj);
    
    %plot_overlap_task(EEG, 'raw', config.chs, 0, only_before);
    %plot_overlap_task(EEG, 'raw-mean', config.chs, 1, only_before);
    %plot_overlap_task(cEEG, 'high-low filtered', config.chs, 1, only_before);
    
    %% Characteristics
    % POWER
    %EEG = eeg_load( subjdir, 'pEEG_global' );
    %plot_overlap_task(EEG, 'power', config.chs, 0, only_before, @erd_ers, EEG.srate, floor(EEG.srate/5));
    
    % ERD/ERS
    EEG = eeg_load( subjdir, 'pEEG_8_13', 'pEEG_13_26', 'pEEG_26_45' );
    plot_bands_overlap_task(EEG, 'ERD-ERS bands', config.chs, 0, only_before, @erd_ers, EEG(1).srate, floor(EEG(1).srate/5));
    
    %input('[Enter] para continuar...');
    
    fprintf('\n\n');
    clear EEG;
end

end