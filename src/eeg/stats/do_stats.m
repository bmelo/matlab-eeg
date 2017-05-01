disp('Computing ...');
bEEG = break_bands(EEG, config.bands);
pEEG = epochs_apply(@power_eeg, bEEG);
erdEEG = epochs_apply(@erd_ers, bEEG, bEEG(1).srate, floor(bEEG(1).srate/5) );

% 
results.stats.global = testConds( pEEG, 'testF' );
results.stats.bands  = testConds( erdEEG, 'testF' );

fprintf('\n### %s ###\n', subj);
print_report(pEEG, results.stats.global);
fprintf('\n\n')

%save( results_file, 'results' );
generate_SL = 1;