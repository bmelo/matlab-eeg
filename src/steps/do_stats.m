disp('Computing ...');

EEG = eeg_load(subjdir, 'pEEG_global');
results.channels = {EEG.chanlocs(:).labels};
srate = EEG.srate;

%% ALL bands
erdEEG = epochs_apply(@erd_ers, EEG, srate, floor(srate/5), [srate*5 srate*10] );

results.stats.global.power = testConds( EEG, 'testF' );
results.stats.global.sync  = testConds( erdEEG, 'testF' );
clear EEG erdEEG;


%% Separating bands
EEG = eeg_load( subjdir, 'pEEG_8_13', 'pEEG_13_26', 'pEEG_26_45' );
erdEEG = epochs_apply(@erd_ers, EEG, srate, floor(srate/5), [srate*5 srate*10] );

results.stats.bands.power = testConds( EEG, 'testF' );
results.stats.bands.sync  = testConds( erdEEG, 'testF' );
clear EEG erdEEG;

% Saving
results_file = fullfile( config.outdir_base, subj, 'results.mat' );
save( results_file, 'results' );
