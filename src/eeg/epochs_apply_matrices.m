function [ EEG ] = epochs_apply_matrices( hFunc, varargin )
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
        
        varargin{1} = signal;
        if ndims(signal.(cond)) == 3
            treat_all_pieces();
        else
            treat_signal(varargin{:});
        end
    end
end

secs = toc;
fprintf('Finished after %.2f s\n\n', secs);
end


%% Auxiliar function
function treat_signal(varargin)

signal = varargin{1};
temp = signal.(cond)(p);
temp.data = [];

% Each channel
for nCh = 1:size(signal.(cond)(p), 1)
    % Task
    varargin{1} = signal.(cond)(p)(nCh,:);
    temp.data(nCh,:) = utils.apply_func( hFunc, varargin );
end
% adjusting resize
perc = size(temp.data,2) / size(signal.(cond)(p).data,2);
temp.duracao = floor( temp.duracao * perc );
temp.idx_data = floor( temp.idx_data(1) * perc ) : ceil(temp.idx_data(end) * perc);

signal.(cond)(p) = temp;

end


%% Another auxiliar function
function treat_all_pieces(signal, varargin)
% Each piece
for p = 1:size(signal.(cond),2)
    treat_signal();
end

end