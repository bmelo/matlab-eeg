function [ EEG ] = epochs_apply( hFunc, varargin )
%EPOCHS_APPLY Apply function to each epoch
%   Detailed explanation goes here

EEG = varargin{1};
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
            varargin{1} = signal.(cond)(p).data(nCh,:);
            signal.(cond)(p).data(nCh,:) = hFunc( varargin{:} );
            
            % Neutral Before
            varargin{1} = signal.(cond)(p).before(nCh,:);
            signal.(cond)(p).before(nCh,:) = hFunc( varargin{:} );
            
            % Neutral After
            varargin{1} = signal.(cond)(p).after(nCh,:);
            signal.(cond)(p).after(nCh,:) = hFunc( varargin{:} );
            
        end
    end
end

% putting return value
EEG.ext.epochs = signal;


end

