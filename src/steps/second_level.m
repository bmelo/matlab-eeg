function second_level(config)

for nB = 1:size(config.bands, 1)
    band = config.bands(nB,:);
    sBand = sprintf('%d-%d', band);
    
    group    = group_matrix_eeg(config, nB);
    srate    = group.srate;
    channels = group.channels;
    
    erdEEG.data.TASK_T = [group.data(:).TASK_T];
    erdEEG.data.TASK_A = [group.data(:).TASK_A];
    
    erdEEG.srate = srate;
    clear group;
    
    results.stats.sl.bands(nB).erders  = testConds( erdEEG, 'friedman' );
    results.channels = channels;
    
    fprintf('\n\nSECOND LEVEL - ERD/ERS [%s]\n', sBand);
    print_report( results.stats.sl.bands(nB).erders.median, results.channels );
    fprintf('\n\n');
    
end

outfile = fullfile( config.outdir_base, 'results-SL.mat' );
save(outfile, 'results', 'channels');

export_SL_excel( config, outfile );

end
