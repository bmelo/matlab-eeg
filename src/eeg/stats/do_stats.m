disp('Computing ...');
results.stats.bands = testBands( cEEG );
results.stats.conds = testConds( cEEG );
results.stats.condsJoin = testCondsJoin( cEEG );
results.stats.condsJoinRuns = testCondsJoinRuns( cEEG );
save( results_file, 'results' );
generate_SL = 1;