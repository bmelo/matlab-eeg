function second_level(config)

files = {'pEEG_global' 'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'};
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

save('results-SL.mat', 'results');
%load('results-SL.mat');
%load('channels');

% Exporting excel
utils.run('vendors/xlwrite/libsetup.m');
fmt = get(0,'Format');
format longG;
header = [{''} channels];
threshold = ['limiar' {.05}];

%% REPORT DIFF TESTS
% 1 - F-TEST (VARIANCE NORMAL DISTRIBUTION)
% 2 - T-TEST
% 3 - WILCOXON
report_diff_test( 'teste-T', 'ttest' );
report_diff_test( 'teste-F', 'ftest' );
report_diff_test( 'wilcoxon', 'wilcoxon' );

%% REPORT FRIEDMAN TEST
for k = 1:length(files)
    file = files{k};
    xlsdata.(file) = {
        header
        ['POWER'   num2cell( [results(k).stats.sl.friedman.power(:).p] )]
        ['ERD/ERS' num2cell( [results(k).stats.sl.friedman.sync(:).p] ) ]
        ''
        ''
        threshold
    };
end

xlsname = fullfile(config.outdir_base, 'friedman.xlsx');
utils.geraOut( xlsname, xlsdata );

format(fmt); % Back to default format

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% REPORT TEST-F (VARIANCE NORMAL DISTRIBUTION)
function report_diff_test( outfile, testname )

for nF = 1:length(files)
    file = files{nF};
    result = results(nF).stats.sl.(testname);
    xlsdata.(file) = {
        'POWER'
        header
        ['T vs N' num2cell(result.power.T_N_p)]
        ['A vs N' num2cell(result.power.A_N_p)]
        ['T vs A' num2cell(result.power.T_A_p)]
        ''
        'ERD/ERS'
        header
        ['T vs N' num2cell(result.sync.T_N_p) ]
        ['A vs N' num2cell(result.sync.A_N_p) ]
        ['T vs A' num2cell(result.sync.T_A_p) ]
        ''
        ''
        threshold
    };
end
xlsname = fullfile(config.outdir_base, [outfile '.xls']);
utils.geraOut( xlsname, xlsdata );

end

end
