function second_level(config)

files = {'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'};
for k = 1:length(files)
    file  = files{k};
    
    group = group_matrix_eeg(config, file);
    srate = group.srate;
    channels = group.channels;
    
    pEEG.TASK_T = [group.data(:).TASK_T];
    pEEG.TASK_A = [group.data(:).TASK_A];
    clear group;
    mpEEG = mean_matrix(pEEG, srate); % mean power
    
    results(k).stats.sl.ftest.power = testChannels( mpEEG, 'testF' );
    results(k).stats.sl.friedman.power = testChannels( mpEEG, 'friedman' );
    results(k).stats.sl.ttest.power = testChannels( mpEEG, 'testT' );
    results(k).stats.sl.wilcoxon.power = testChannels( mpEEG, 'wilcoxon' );
    clear mEEG;
    
    syncEEG = epochs_apply_matrices(@erd_ers, pEEG, srate, srate/5, [srate*5 srate*10] );
    perc = size(syncEEG.TASK_T,3) / size(pEEG.TASK_T,3);
    clear pEEG;
    msEEG = mean_matrix(syncEEG, srate * perc); % mean sync
    
    results(k).stats.sl.ftest.sync = testChannels( msEEG, 'testF' );
    results(k).stats.sl.friedman.sync = testChannels( msEEG, 'friedman' );
    results(k).stats.sl.ttest.sync = testChannels( msEEG, 'testT' );
    results(k).stats.sl.wilcoxon.sync = testChannels( msEEG, 'wilcoxon' );
end

outfile = fullfile( config.outdir_base, 'results-SL.mat' );
save(outfile, 'results', 'channels');

export_SL_excel( config, outfile );

end
