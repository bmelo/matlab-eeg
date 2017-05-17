function plot_bands_overlap_task( EEG, folder_save, channels, remove_mean, before, mean_func, varargin )
%PLOT_BANDS_OVERLAP_TASK Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3, channels = 1:length(EEG.chanlocs); end
if nargin < 4, remove_mean = 0; end
if nargin < 5, before = 0; end
if nargin < 6, mean_func = []; end

EEG(1).ext.only_before = before;
EEG(1).ext.mean_func.handle = mean_func;
EEG(1).ext.mean_func.args = varargin;

% Checking if needs generate output
save_img = (nargin > 1) && ~isempty(folder_save);
save_dir = fullfile( EEG(1).ext.config.imgsexport_dir, EEG(1).subject, 'imgs', folder_save );

figure;
for chan_num = channels
    chan_name = EEG(1).chanlocs(chan_num).labels;
    plot_channel( EEG, chan_num, remove_mean);
    
    % Putting title
    suptitle( sprintf('%s - %s %s', folder_save, EEG(1).subject, chan_name) );
    
    if save_img
        extra = '';
        if EEG(1).ext.only_before
            extra = '_before';
        end
        file_name = sprintf('%s_%s%s.png', EEG(1).subject, chan_name, extra);
        fprintf('Saving "%s" ...\n', fullfile(save_dir, file_name));
        utils.imgs.print_fig( fullfile(save_dir, file_name) );
    end
end

end

%%%%%%%%%%%%%%%%%%%%
% Plot each channel
%%%%%%%%%%%%%%%%%%%%
function plot_channel( EEG, chan_num, remove_mean )
clf('reset'); % Clear current figure

only_before = EEG(1).ext.only_before;
n_bands = length(EEG);
conds = {'TASK_T' 'TASK_A'};
n_conds = length(conds);
hPlots = zeros(1, length(conds)*n_bands);

for nB = 1:n_bands
    epochs = EEG(nB).ext.epochs;
    epochsM = matrices(epochs);
    band = EEG(nB).ext.bands;
    
    % Plots each condition
    for nC = 1:n_conds
        % preparing vars
        cond = conds{nC};
        ref = epochs.(cond)(1);
        lims = [ref.idx_data(1) ref.idx_data(end)];
        % Check if only needs neutral that comes before main task
        if only_before
            epochsM.(cond)(:,:,lims(end)+1:end) = [];
            lims(2) = [];
        end
        
        mult = 1;
        if strcmp(cond, 'TASK_A')
            mult = -1;
        end
        signal = squeeze( epochsM.(cond)(chan_num,:,:) )';
        signal_mean = squeeze( mean(signal, 2) );
        if( remove_mean )
            % To remove, both matrix need match in size
            signal = signal- repmat(signal_mean, 1, size(signal,2));
        end
        
        % Apply function only to mean
        if isa(EEG(1).ext.mean_func.handle, 'function_handle')
            mean_func = EEG(1).ext.mean_func;
            args = [signal_mean, mean_func.args];
            signal_mean = utils.apply_func(mean_func.handle, args);
            lims = lims*length(signal_mean)/length(signal);
        end
        
        % Plotting
        nP = nC+((nB-1)*n_conds);
        hPlots(nP) = subplot( n_bands, n_conds, nP );
        title( sprintf('%s [%d-%d]', cond, band(1), band(2)) );
        plot_task( signal_mean, lims, mult );
    end
end

fix_columns( hPlots, 66 );

end