function [ matEEG ] = epochs_apply_matrices( hFunc, varargin )
%EPOCHS_APPLY Apply function to each epoch
%   Detailed explanation goes here
global handle;
handle = hFunc;

tic;
fprintf('Applying function <a href="matlab:help %1$s">%1$s</a>\n', func2str(hFunc));

matEEG = varargin{1};

for nE = 1:length(matEEG)
    matEEG = matEEG(nE);
    conds = fields(matEEG);
    
    % Each condition
    for nCond = 1:length(conds)
        cond = conds{nCond};
        
        varargin{1} = matEEG.(cond);
        if ndims( matEEG.(cond) ) == 3
            matEEG(nE).(cond) = treat_all_pieces( varargin{:} );
        else
            matEEG(nE).(cond) = treat_signal(varargin{:});
        end
    end
end

secs = toc;
fprintf('Finished after %.2f s\n\n', secs);
clear handle;
end


%% Auxiliar function
function signal = treat_signal(varargin)
global handle;
signal = varargin{1};
temp = [];

% Each channel
for nCh = 1:size(signal, 1)
    % Task
    varargin{1} = signal(nCh,:);
    temp(nCh,:) = utils.apply_func( handle, varargin );
end

% adjusting resize
signal = temp;

end


%% Another auxiliar function
function signal = treat_all_pieces(varargin)

matrixEEG = varargin{1};
% Each piece
for p = 1:size(matrixEEG,2)
    varargin{1} = squeeze(matrixEEG(:,p,:));
    signal(:, p, :) = treat_signal( varargin{:} );
end

end