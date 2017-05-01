function epochs = epocas_v2( EEG )
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
    
    epoca.inicio = ceil(evt.latency);
    epoca.end = ceil(EEG.event(k+1).latency);
    epoca.duracao = (epoca.end - epoca.inicio)+1;
    epoca.raw = epoca;
    
    first_pt = epoca.inicio - durNeutral;
    last_pt = epoca.end + durNeutral;
    epoca.data = EEG.data(:, first_pt:last_pt );
    
    if epoca.duracao < 10
        continue;
    end
    epoca.evt = evt;
    
    % Neutrals
    epoca.idx_data = (epoca.inicio:epoca.end) - first_pt+1;
    
    % Add or create structure
    try
        epochs.( codes{type,1} )(end+1) = epoca;
    catch e
        epochs.( codes{type,1} ) = epoca;
    end
    epoca = [];
end

end