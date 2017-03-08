function [EEG, AUX] = prepare_eeg( config, subject, srate )

outdir = fullfile(config.outdir_base, subject);
eeg_file_resample = fullfile(outdir, sprintf('eeg_%d.mat', srate));

%% Loading EEG and AUX
[EEG, AUX] = load_data(config, subject, eeg_file_resample);
% Splitting EEG and AUX, if necessary
if isempty(AUX)
    disp('splitting EEG -> EEG and AUX');
    labelsAUX = {EEG.chanlocs([32 65:68]).labels}; %ECG, GSR, ACC_x, ACC_y, ACC_z
    AUX = pop_select( EEG, 'channel', labelsAUX);
    EEG = pop_select( EEG, 'nochannel', labelsAUX);
    save( fullfile(outdir, 'eeg.mat'), 'EEG', 'AUX', '-v7.3');
end

%% Resampling to srate, if higher than srate
if( EEG.srate > srate )
    EEG = pop_resample( EEG, srate );
    AUX = pop_resample( AUX, srate );
    save( eeg_file_resample, 'EEG', 'AUX', '-v7.3');
end

%% Clearing events
%Inserting events using log
%extract_events;
%fields = {'type', 'latency','duration', 'init_time', 'init_index'};
%[EEG, eventnumbers] = pop_importevent(EEG, 'event', events, 'fields', fields,'append', 'no', 'timeunit', 1 );

%% HIGH/LOW FILTER
%EEG = filter_bands( EEG, [7 45]);
%save( fullfile(outdir, 'eeg_500_f.mat'), 'EEG', 'AUX', '-v7.3');

end


%% Load and resampling data
function [EEG, AUX] = load_data( config, subj, alt_file )
import utils.resolve_names;
import utils.path.basename;

AUX = [];
rawdir = fullfile(config.rawdir_base, subj);

% Searching EEG already downsampled
if( exist( alt_file, 'file' ) )
    fprintf('loading data\n%s\n\n', alt_file);
    load( alt_file );
    disp('fixing data info');
    EEG.subject =subj;
    EEG.filename = basename(alt_file);
    EEG.filepath = fileparts(alt_file);
    EEG.ext.config = config;
    EEG.ext.type = 'raw_data';
    AUX.subject =subj;
    AUX.filename = basename(alt_file);
    AUX.filepath = fileparts(alt_file);
    AUX.ext = EEG.ext;
    save( alt_file, 'EEG', 'AUX', '-v7.3');
else
    fname = resolve_names( fullfile(rawdir, '*.vhdr') );
    fprintf('loading data\n%s\n\n', fname{1});
    
    EEG = pop_loadbv( rawdir, basename(fname{1}) );

    EEG.subject = subj;
    EEG.filename = basename(fname{1});
    EEG.filepath = rawdir;
    EEG.ext.config = config;
    EEG.ext.type = 'raw_data';
    
    % Changing labels, if necessary
    if exist( fullfile(rawdir, '/canais.txt'), 'file' )
        labels = textread( fullfile(rawdir, '/canais.txt'), '%s' );
        for k=1:length( EEG.chanlocs )
            EEG.chanlocs(k).labels = labels{k};
        end
    end
end

end
