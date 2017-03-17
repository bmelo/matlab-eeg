function signal = match_length(signal, direction)
% MATCH_LENGTH Leaves each piece with the same size
% Parameters: signal, direction (0 - right remove, 1 - left remove)

if ~exist('direction', 'var'), direction = 0; end

duracao = min([signal(:).duracao]);
% Each piece
for p=1:length(signal)
    start_pt = signal(p).idx_data(1);
    end_pt   = signal(p).idx_data(end);
    if duracao == size(signal(p).data,2)
        continue;
    end
    
    % Do the same for all channels
    % Checking direction
    if direction == 0 % From le
        signal(p).data(:,start_pt+duracao:end_pt) = [];
    else
        signal(p).data(:,start_pt:end_pt-duracao) = [];
    end
    
    %Updates duracao
    signal(p).duracao = duracao;
    signal(p).idx_data = start_pt : (start_pt + duracao - 1);
end