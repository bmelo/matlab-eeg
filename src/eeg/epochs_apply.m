function [ EEG ] = epochs_apply( EEG, hFunc, varargin )
%EPOCHS_APPLY Apply function to each epoch
%   Detailed explanation goes here

signal = EEG.ext.epochs;
conds = fields(signal);

% Each condition
for nCond = 1:length(conds)
    cond = conds{nCond};
    
    % Each piece
    for p = 1:length(signal.(cond))
        
        % Each channel
        for nCh = 1:size(signal.(cond)(p).data, 1)
            
            % Task
            args = [signal.(cond)(p).data(nCh,:) varargin];
            signal.(cond)(p).data(nCh,:) = hFunc( args{:} );
            
            % Neutral Before
            args = [signal.(cond)(p).before(nCh,:) varargin];
            signal.(cond)(p).before(nCh,:) = hFunc( args{:} );
            
            % Neutral After
            args = [signal.(cond)(p).after(nCh,:) varargin];
            signal.(cond)(p).after(nCh,:) = hFunc( args{:} );
            
        end
    end
end

% putting return value
EEG.ext.epochs = signal;


end

