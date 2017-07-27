function epochs = epochs_v2( EEG )
% EPOCHS_V2 splitting moods putting 6s before of NEUTRAL and 6s after of NEUTRAL

codes = {
    'TASK_T',  'S  2'
    'TASK_A',  'S  3'
};
nEvts = length(EEG.event);
durNeutral = EEG.ext.config.neutral_length * EEG.srate;

% Breaking epochs
for k=1:nEvts
    evt = EEG.event(k);
    type = find(strcmp(evt.type, codes(:,2)));
    %% If is not a marker with specified codes ('S  2', 'S  3')
    if ~any( type > 0 )
        continue
    end
    
    epoch.inicio = ceil(evt.latency);
    epoch.end = ceil(EEG.event(k+1).latency);
    epoch.duracao = (epoch.end - epoch.inicio)+1;
    epoch.raw = epoch;
    
    first_pt = epoch.inicio - durNeutral;
    last_pt = epoch.end + durNeutral;
    epoch.data = EEG.data(:, first_pt:last_pt );
    
    if epoch.duracao < 10
        continue;
    end
    epoch.evt = evt;
    
    % Neutrals
    epoch.idx_data = (epoch.inicio:epoch.end) - first_pt+1;
    
    % Add or create structure
    try
        epochs.( codes{type,1} )(end+1) = epoch;
    catch e
        epochs.( codes{type,1} ) = epoch;
    end
    epoch = [];
end

end