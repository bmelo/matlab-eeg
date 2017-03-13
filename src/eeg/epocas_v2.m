function epochs = epocas_v2( EEG )
% EPOCHS_V2 splitting moods putting 6s before of NEUTRAL and 6s after of NEUTRAL

codes = {
    'TASK_T',  'S  2'
    'TASK_A',  'S  3'
};

nEvts = length(EEG.event);
epocaEmpty = struct('inicio',[],'end',[],'duracao',[],'data',[],'evt',{},'before',[],'after',[]);
for nC = 1:length(codes)
    epochs.(codes{nC,1}) = epocaEmpty;
end

% Breaking epochs
for k=1:nEvts
    evt = EEG.event(k);
    type = find(strcmp(evt.type, codes(:,2)));
    %% ??
    if ~any( type > 0 )
        continue
    end
    
    epoca.inicio = ceil(evt.latency);
    epoca.end = ceil(EEG.event(k+1).latency);
    epoca.duracao = (epoca.end - epoca.inicio)+1;
    
    if epoca.duracao < 10
        continue;
    end
    
    epoca.data = EEG.data( :, epoca.inicio:epoca.end );
    epoca.evt = evt;
    
    % Neutrals
    durNeutral = EEG.ext.config.neutral_length * EEG.srate;
    epoca.before = EEG.data( :, ( (epoca.inicio-durNeutral):epoca.inicio) -1 );
    epoca.after  = EEG.data( :, ( epoca.end: (epoca.end+durNeutral)) +1 );
    
    epochs.( codes{type,1} )(end+1) = epoca;
end

end