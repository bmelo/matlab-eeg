disp('Computing ...');

%% Going through all bands
EEG = eeg_load( subjdir, 'pEEG_8_13', 'pEEG_13_26', 'pEEG_26_45' );
srate = EEG.srate;
erdEEG = epochs_apply(@erd_ers, EEG, srate, floor(srate/5), [srate*5 srate*10] );

results.stats.bands.power = testConds( EEG, 'testF' );
results.stats.bands.sync  = testConds( erdEEG, 'testF' );
results.channels = {EEG(1).chanlocs(:).labels};
clear EEG erdEEG;

% Saving
results_file = fullfile( config.outdir_base, subj, 'results.mat' );
save( results_file, 'results' );
