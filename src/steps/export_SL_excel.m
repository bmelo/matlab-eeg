function export_SL_excel( config, statsfile )
%EXPORT_SL_EXCEL Summary of this function goes here
%   Detailed explanation goes here

load(statsfile, 'results', 'channels');

files = {'pEEG_8_13' 'pEEG_13_26' 'pEEG_26_45'};

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

