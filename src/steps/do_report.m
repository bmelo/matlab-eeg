%cEEG.printReport( results.stats.bands, '\n\n-- Bands --', 2, [3 5] );
%cEEG.printReport( results.stats.conds, '\n\n-- Conds --', 1, [2 3] );
%cEEG.printReport( results.stats.condsJoin, '\n\n-- CondsJoin --', 1, [1 2] );
%cEEG.printReport( results.stats.condsJoinRuns, '\n\n-- CondsJoinRUNs --', 2, [1 1] );


%% Printing report
fprintf('\n\nPower Global')
print_report( results.stats.global.power{1}, results.channels );
disp('\n\nERD/ERS Global')
print_report( results.stats.global.sync{1}, results.channels );

fprintf('\n\nPower [8-13]')
print_report( results.stats.bands.power{1}, results.channels );
fprintf('\n\nERD/ERS [8-13]')
print_report( results.stats.bands.sync{1}, results.channels );

fprintf('\n\nPower [13-26]')
print_report( results.stats.bands.power{2}, results.channels );
fprintf('\n\nERD/ERS [13-26]')
print_report( results.stats.bands.sync{2}, results.channels );

fprintf('\n\nPower [26-45]')
print_report( results.stats.bands.power{3}, results.channels );
fprintf('\n\nERD/ERS [26-45]')
print_report( results.stats.bands.sync{3}, results.channels );