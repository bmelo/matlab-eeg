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
    
    results(k).stats.sl.ftest.power = testChannels( pEEG, srate, 'testF' );
    results(k).stats.sl.ftest.sync = testChannels( syncEEG, srate*perc, 'testF' );
    results(k).stats.sl.friedman.power = testChannels( pEEG, srate, 'friedman' );
    results(k).stats.sl.friedman.sync = testChannels( syncEEG, srate*perc, 'friedman' );
    
    %% Printing report
    fprintf('\n\nPower - %s', file)
    print_report( results(k).stats.sl.ftest.power, channels );
    fprintf('\n\nERD/ERS - %s', file)
    print_report( results(k).stats.sl.ftest.sync, channels );
    fprintf('\n\n\n')
    fprintf('\n\nPower - %s', file)
    print_report( results(k).stats.sl.friedman.power, channels );
    fprintf('\n\nERD/ERS - %s', file)
    print_report( results(k).stats.sl.friedman.sync, channels );
    fprintf('\n\n\n')
end

save('results-SL.mat', 'results');

% Exporting excel
utils.run('vendors/xlwrite/setup.m');

header = [{''} channels];
for k = 1:length(files)
    file = files{k};
    xlsdata.(file) = {
        'POWER'
        header
        ['T vs N' num2cell(results(k).stats.sl.ftest.power.T_N_p)]
        ['A vs N' num2cell(results(k).stats.sl.ftest.power.A_N_p) ]
        ['T vs A' num2cell(results(k).stats.sl.ftest.power.T_A_p) ]
        ''
        'ERD/ERS'
        header;
        ['T vs N' num2cell(results(k).stats.sl.ftest.sync.T_N_p) ]
        ['A vs N' num2cell(results(k).stats.sl.ftest.sync.A_N_p) ]
        ['T vs A' num2cell(results(k).stats.sl.ftest.sync.T_A_p) ]
        ''
        ''
        'limiar' 0.05
    };
end

xlsname = fullfile(config.outdir_base, 'test-f.xlsx');
utils.geraOut( xlsname, xlsdata );



header = [{''} channels];
for k = 1:length(files)
    file = files{k};
    xlsdata.(file) = {
        header
        ['POWER'   num2cell(results(k).stats.sl.friedman.power.p)]
        ['ERD/ERS' num2cell(results(k).stats.sl.friedman.sync.p) ]
        ''
        ''
        'limiar' 0.05
    };
end

xlsname = fullfile(config.outdir_base, 'friedman.xlsx');
utils.geraOut( xlsname, xlsdata );




















