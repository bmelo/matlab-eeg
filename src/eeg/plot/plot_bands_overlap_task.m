function plot_bands_overlap_task( EEG, folder_save, channels, remove_mean, varargin )
%PLOT_OVERLAP_TASK Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3, channels = 1:length(EEG.chanlocs); end
if nargin < 4, remove_mean = 0; end
EEG(1).ext.only_before = utils.Var.arg_exist(varargin, 'before');

% Checking if needs generate output
save_img = (nargin > 1) && ~isempty(folder_save);
save_dir = fullfile( EEG(1).ext.config.outdir_base, EEG(1).subject, 'imgs', folder_save );

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
        file_name = sprintf('%s_%03d_%s%s.png', EEG(1).subject, chan_num, chan_name, extra);
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
        
        % Plotting
        subplot( n_bands, n_conds, nC+((nB-1)*n_conds) );
        title( sprintf('%s [%d-%d]', cond, band(1), band(2)) );
        plot_task( signal_mean, lims, mult );
    end
end

%% Adjusting plots
first = 1;
for nC = 1:n_conds
    cond = conds{nC};
    n_pts = length(epochsM.(cond));
    for nP = nC:2:(n_bands*n_conds)
        subplot(n_bands, n_conds, nP);    
        hold on;
        xlim([1,n_pts]);
%         datetick('x', 'MM:SS', 'keeplimits', 'keepticks');
        hold off;
    end
    first = first + length( epochs.(cond) );
end

end


%%%%%%%%%%%%%%%%%%
% Plot conditions
%%%%%%%%%%%%%%%%%%
function plot_task( signal, lims, mult )
import utils.plot.lines.vline;

% Plotting signals of one channel
data = squeeze( signal );

% Plotting each piece
hold on;
plot( data );

% Putting lines
vline(lims(1), '--g', 'start');
if length(lims) == 2
    vline(lims(2), '--r', 'end');
end

% % Plotting experimental design
% ampA = (max( data(:) ) - min( data(:) )) / 2;

% task_x = lims(1):lims(2);
% interv = linspace(-pi/2, 5.5*pi, length(task_x));
% interv = -pi/2 : (6*pi/(length(task_x)-1)) : (6*pi - pi/2);
% plot( task_x, mult* ( sin(interv)*ampA+(ampA/2) ), '--k', 'LineWidth', .5 )

hold off;
end