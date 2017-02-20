
if( ~isdir(outdir) )
    mkdir(outdir)
end

if( exist( fullfile(outdir, 'eeg_500.mat'), 'file' ) )
    load( fullfile(outdir, 'eeg_500.mat') );
else
    fname = dir( fullfile(rawdir, '*.vhdr') );
    
    EEG = pop_loadbv( rawdir, fname.name );
    
    %Changing labels, if necessary
    if exist( fullfile(rawdir, '/canais.txt'), 'file' )
        labels = textread( fullfile(rawdir, '/canais.txt'), '%s' );
        for k=1:length( EEG.chanlocs )
            EEG.chanlocs(k).labels = labels{k};
        end
    end
    
    %Clearing events
    %Inserting events using log
    %extract_events;
    %fields = {'type', 'latency','duration', 'init_time', 'init_index'};
    %[EEG, eventnumbers] = pop_importevent(EEG, 'event', events, 'fields', fields,'append', 'no', 'timeunit', 1 );
    
    %Splitting data and aux
    labelsAUX = {EEG.chanlocs([32 65:68]).labels}; %ECG, GSR, ACC_x, ACC_y, ACC_z
    AUX = pop_select( EEG, 'channel', labelsAUX);
    EEG = pop_select( EEG, 'nochannel', labelsAUX);
    save( fullfile(outdir, 'eeg.mat'), 'EEG', 'AUX', '-v7.3');
    
    %Resampling to 500Hz
    EEG = pop_resample( EEG, 500 );
    AUX = pop_resample( AUX, 500 );
    save( fullfile(outdir, 'eeg_500.mat'), 'EEG', 'AUX', '-v7.3');
end