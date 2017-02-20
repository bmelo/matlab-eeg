disp('Computing ...');
results.stats.bands = testBands( epochs );
results.stats.conds = testConds( epochs );
results.stats.condsJoin = testCondsJoin( epochs );
results.stats.condsJoinRuns = testCondsJoinRuns( epochs );
save( results_file, 'results' );
generate_SL = 1;