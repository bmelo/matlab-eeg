disp('Computing ...');
pEEG = epochs_apply(@power_eeg, cEEG);

results.stats.conds = testConds( pEEG );
%results.stats.bands = testBands( pEEG );
%results.stats.conds = testConds( pEEG );
%results.stats.condsJoin = testCondsJoin( pEEG );
%results.stats.condsJoinRuns = testCondsJoinRuns( pEEG );

fprintf('\n### %s ###\n', subj);
print_report(pEEG, results.stats.conds);
fprintf('\n\n')

%save( results_file, 'results' );
generate_SL = 1;