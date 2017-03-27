function [ EEG ] = epochs_apply( hFunc, varargin )
%EPOCHS_APPLY Apply function to each epoch
%   Detailed explanation goes here
tic;
fprintf('Applying function <a href="matlab:help %1$s">%1$s</a>\n', func2str(hFunc));

EEG = varargin{1};

for nE = 1:length(EEG)
    signal = EEG(nE).ext.epochs;
    conds = fields(signal);
    % Each condition
    for nCond = 1:length(conds)
        cond = conds{nCond};
        
        % Each piece
        for p = 1:length(signal.(cond))
            
            temp = signal.(cond)(p);
            temp.data = [];
            
            % Each channel
            for nCh = 1:size(signal.(cond)(p).data, 1)
                % Task
                varargin{1} = signal.(cond)(p).data(nCh,:);
                temp.data(nCh,:) = utils.apply_func( hFunc, varargin );
            end
            % adjusting resize
            perc = size(temp.data,2) / size(signal.(cond)(p).data,2);
            temp.duracao = floor( temp.duracao * perc );
            temp.idx_data = floor( temp.idx_data(1) * perc ) : ceil(temp.idx_data(end) * perc);
            
            signal.(cond)(p) = temp;
        end
    end
    % putting return value
    EEG(nE).ext.epochs = signal;
end

secs = toc;
fprintf('Finished after %.2f s\n\n', secs);
end