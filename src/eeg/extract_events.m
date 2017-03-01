% [EEG, eventnumbers] = pop_importevent(EEG, 'event', ...
%           'event_values.txt', 'fields', {'type', 'latency','condition' }, ...
%           'append', 'no', 'align', 0, 'timeunit', 1E-3 );
import utils.Time;

[~, logfile] = fileattrib( fullfile(rawdir, '*.log') );
eegfile = dir( fullfile(rawdir, '*.eeg') );
eventsfile = fullfile( outdir, 'events.mat' );

startTime = Time.extractDate( eegfile.name );

%% READING LOG EVENTS
events = {};
fid = fopen( logfile(end).Name );
tline = fgets(fid);
while ischar(tline)
    eventTime = Time.extractDate(tline, true);
    if( eventTime ~= false ) %Is a marker
        eventType = regexp(tline, '- (.*)\s*$', 'tokens', 'once');
        eventType = strtrim(eventType{1});
        elapsedSeconds = Time.diff( eventTime, startTime );
        fprintf('%.3f %s\n', elapsedSeconds, eventType );
        events{end+1, 1} = eventType;
        events{end, 2} = elapsedSeconds; %latency
        events{end, 3} = 0; %duration
        events{end, 4} = elapsedSeconds; %init_time
        events{end, 5} = floor(elapsedSeconds * 500); %init_index
    end
    tline = fgets(fid);
end
fclose(fid);

%Calculating duration
for k = 1:(length(events)-1)
    if any(strcmp(events{k,1},{'TASK', 'NEUTRAL'}) )
        events{k, 3} = events{k+1,4}-events{k, 4};
    end
end

fprintf('Salvando arquivo: %s', eventsfile);
save(eventsfile, 'events');