function epochs = epocas( EEG )

nEvts = length(EEG.event);
epocaEmpty = struct('inicio',[],'end',[],'duracao',[],'data',[],'evt',{});
epochs = struct('NEUTRAL',epocaEmpty,'TASK_T',epocaEmpty,'TASK_A',epocaEmpty);
codes = {
    'NEUTRAL', 'S  1'
    'TASK_T',  'S  2'
    'TASK_A',  'S  3'
};

for k=1:nEvts
    evt = EEG.event(k);
    type = find(strcmp(evt.type, codes(:,2)));
    %% ??
    if ~any( type > 0 )
        continue
    end
    
    epoca.inicio = ceil(evt.latency);
    epoca.end = ceil(EEG.event(k+1).latency);
    epoca.duracao = epoca.end - epoca.inicio;
    epoca.data = EEG.data( :, epoca.inicio:epoca.end );
    epoca.evt = evt;
    
    if epoca.duracao < 10
        continue;
    end
    
    epochs.( codes{type,1} )(end+1) = epoca;
end

end