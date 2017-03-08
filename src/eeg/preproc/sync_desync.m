function EEG = sync_desync(EEG)
% SYNC_DESYNC
% Details

epochs = EEG.ext.epochs;
% Each condition
for field = fields(epochs)'
    cond = field{1};
    
    %% Preparing sync/desync
    % Each piece
    for p = 1:length(epochs.(cond))
        epochs.(cond)(p).data = epochs.(cond)(p).data .^2;
    end
end

EEG.ext.epochs = epochs;
EEG.ext.type = 'sync_desync';

end