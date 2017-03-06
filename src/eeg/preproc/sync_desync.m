function epochs = sync_desync(epochs)
% SYNC_DESYNC
% Details

% Each condition
for field = fields(epochs)'
    cond = field{1};
    
    %% Preparing sync/desync
    % Each piece
    for p = 1:length(epochs.(cond))
        epochs.(cond)(p).data = epochs.(cond)(p).data .^2;
    end
    
end

end