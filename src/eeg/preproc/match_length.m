function signal = match_length(signal, direction)
% MATCH_LENGTH Leaves each piece with the same size
% Parameters: signal, direction (0 - right remove, 1 - left remove)

if ~exist('direction', 'var'), direction = 0; end

width = min([signal(:).duracao]);
% Each piece
for p=1:length(signal)
    sizeW = size(signal(p).data,1);
    if sizeW == width
        continue;
    end
    
    % Do the same for all channels
    % Checking direction
    if direction == 0 % From le
        signal(p).data(:,width+1:end) = [];
    else
        signal(p).data(:,1:end-width) = [];
    end
    %Updates duracao
    signal(p).duracao = size(signal(p).data,2);
end