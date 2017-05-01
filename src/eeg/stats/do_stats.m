disp('Computing ...');

results.channels = {cEEG.chanlocs(:).labels};

%% ALL bands
pEEG = epochs_apply(@power_eeg, cEEG);
erdEEG = epochs_apply(@erd_ers, cEEG, cEEG.srate, floor(cEEG.srate/5) );

results.stats.global.power = testConds( pEEG, 'testF' );
results.stats.global.sync  = testConds( erdEEG, 'testF' );
clear pEEG erdEEG;


%% Separating bands
bEEG = break_bands(EEG, config.bands);
pEEG = epochs_apply(@power_eeg, bEEG);
erdEEG = epochs_apply(@erd_ers, bEEG, bEEG(1).srate, floor(bEEG(1).srate/5) );

results.stats.bands.power = testConds( pEEG, 'testF' );
results.stats.bands.sync  = testConds( erdEEG, 'testF' );
clear EEG bEEG pEEG erdEEG;

% Saving
results_file = fullfile( config.outdir_base, subj, 'results.mat' );
save( results_file, 'results' );
