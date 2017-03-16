function [ EEG ] = epochs_apply( hFunc, varargin )
%EPOCHS_APPLY Apply function to each epoch
%   Detailed explanation goes here
tic;
fprintf('Applying function <a href="matlab:help %1$s">%1$s</a>\n', func2str(hFunc));

EEG = varargin{1};
signal = EEG.ext.epochs;
conds = fields(signal);

% Each condition
for nCond = 1:length(conds)
    cond = conds{nCond};
    
    % Each piece
    for p = 1:length(signal.(cond))
        
        temp = signal.(cond)(p);
        temp.data = [];
        temp.before = [];
        temp.after = [];
        
        % Each channel
        for nCh = 1:size(signal.(cond)(p).data, 1)    
            % Task
            varargin{1} = signal.(cond)(p).data(nCh,:);
            temp.data(nCh,:) = hFunc( varargin{:} );
            
            % Neutral Before
            varargin{1} = signal.(cond)(p).before(nCh,:);
            temp.before(nCh,:) = hFunc( varargin{:} );
            
            % Neutral After
            varargin{1} = signal.(cond)(p).after(nCh,:);
            temp.after(nCh,:) = hFunc( varargin{:} );
        end
        signal.(cond)(p) = temp;
    end
end

% putting return value
EEG.ext.epochs = signal;

secs = toc;
fprintf('Finished after %.2f s\n\n', secs);
end

