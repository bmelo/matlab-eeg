disp('Computing ...');

%% Separating bands
erdEEG = eeg_load( subjdir, 'syncEEG_8_13', 'syncEEG_13_26', 'syncEEG_26_45' );

% Exporting to Analyzer
srate = erdEEG(1).srate;
int_del = floor(56 * srate) + 1; % to remove end
for k=1:3
    % Removing bad channels
    p_ignore = find( [config.ignore{:,1}] == subjN );
    if p_ignore
        erdEEG(k) = ignore_bad_channels( erdEEG(k), config.ignore{ p_ignore, 2 } );
    end
    
    mERD = matrices(erdEEG(k));
    
    conds = fields(mERD);
    for cond = conds'
        % selecting data
        mDATA = mERD.( cond{1} );
        mDATA(:,:,int_del:end) = []; % removing end
        
        % merging epochs
        mDATA = permute(mDATA, [1,3,2]);
        mDATA = mDATA(:,:);
        
        % exporting
        p.data = mDATA;
        p.srate = srate;
        p.channels = {erdEEG(1).chanlocs(:).labels};
        band = sprintf('%02d-%02d', erdEEG(k).ext.bands);
        outfile = [subj '_' band '_' cond{1}];
        export_eeglab( p, outfile);
    end
    
end
return


results.stats.bands.power = testConds( EEG, 'testF' );
results.stats.bands.sync  = testConds( erdEEG, 'testF' );
clear EEG erdEEG;

% Saving
results_file = fullfile( config.outdir_base, subj, 'results.mat' );
save( results_file, 'results' );
