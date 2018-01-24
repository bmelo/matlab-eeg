function [ EEG ] = epochs_apply_all_chs( hFunc, varargin )
%EPOCHS_APPLY Apply function to each epoch
%   Detailed explanation goes here
tic;
fprintf('Applying function <a href="matlab:help %1$s">%1$s</a>\n', func2str(hFunc));

EEG = varargin{1};
is_main_struct = isfield(EEG, 'ext');

for nE = 1:length(EEG)
    if is_main_struct
        signal = EEG(nE).ext.epochs;
    else
        signal = EEG;
    end
    conds = fields(signal);
    % Each condition
    for nCond = 1:length(conds)
        cond = conds{nCond};
        
        % Each piece
        for p = 1:length(signal.(cond))
            
            temp = signal.(cond)(p);
            temp.data = [];
            
            % Task
            varargin{1} = signal.(cond)(p).data;
            temp.data = utils.apply_func( hFunc, varargin );
            
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