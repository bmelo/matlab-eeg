function second_level(config)

files = {'pEEG_global' 'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'};
for k = 1:length(files)
    file  = files{k};
    
    group = group_matrix_eeg(config, file);
    srate = group.srate;
    channels = group.channels;
    
    pEEG.TASK_T = [group.data(:).TASK_T];
    pEEG.TASK_A = [group.data(:).TASK_A];
    
    syncEEG = epochs_apply_matrices(@erd_ers, pEEG, srate, srate/5, [srate*5 srate*10] );
    perc = size(syncEEG.TASK_T,3) / size(pEEG.TASK_T,3);
    
    results.stats.sl.global.power = testChannels( pEEG, srate, 'testF' );
    results.stats.sl.global.sync = testChannels( syncEEG, srate*perc, 'testF' );
    
    %% Printing report
    fprintf('\n\nPower - %s', file)
    print_report( results.stats.sl.global.power, channels );
    fprintf('\n\nERD/ERS - %s', file)
    print_report( results.stats.sl.global.sync, channels );
    fprintf('\n\n\n')
end