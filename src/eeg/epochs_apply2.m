function [ EEG ] = epochs_apply2( hFunc, varargin )
%EPOCHS_APPLY Apply function to each epoch
%   Detailed explanation goes here
tic;
fprintf('Applying function <a href="matlab:help %1$s">%1$s</a>\n', func2str(hFunc));

EEG = varargin{1};
EEG2 = varargin{2};
is_main_struct = isfield(EEG, 'ext');

for nE = 1:length(EEG)
    if is_main_struct
        signal = EEG(nE).ext.epochs;
        signal2 = EEG2(nE).ext.epochs;
    else
        signal = EEG;
    end
    conds = fields(signal);
    % Each condition
    for nCond = 1:length(conds)
        cond = conds{nCond};
        
        % Each piece
        for p = 1:length(signal.(cond))
            
            nChs = size(signal.(cond)(p).data, 1);
            temp = signal.(cond)(p);
            temp.data = [];
            
            % Each channel
            for nCh = 1:nChs
                % Task
                varargin{1} = signal.(cond)(p).data(nCh,:);
                varargin{2} = signal2.(cond)(p).data(nCh,:);
                temp.data(nCh,:) = utils.apply_func( hFunc, varargin );
                % Allocating data to be more fast
                if nCh == 1
                    aux = temp.data;
                    nItems = size(temp.data(1,:), 2);
                    temp.data = zeros( nChs, nItems );
                    temp.data(nCh,:) = aux;
                end
            end
            % adjusting resize
            perc = size(temp.data,2) / size(signal.(cond)(p).data,2);
            temp.duracao = floor( temp.duracao * perc );
            temp.lims_data = [floor( temp.lims_data(1) * perc ) ceil(temp.lims_data(2) * perc)];
            
            signal.(cond)(p) = temp;
        end
    end
    
    if is_main_struct
        % putting return value
        EEG(nE).srate = EEG(nE).srate * perc;
        EEG(nE).ext.epochs = signal;
    end
end

secs = toc;
fprintf('Finished after %.2f s\n\n', secs);
end