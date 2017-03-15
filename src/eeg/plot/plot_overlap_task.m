function plot_overlap_task( EEG, folder_save, channels, remove_mean, varargin )
%PLOT_OVERLAP_TASK Summary of this function goes here
%   Detailed explanation goes here

if nargin < 3, channels = 1:length(EEG.chanlocs); end
if nargin < 4, remove_mean = 0; end
EEG.ext.only_before = utils.Var.arg_exist(varargin, 'before');

% Checking if needs generate output
save_img = (nargin > 1) && ~isempty(folder_save);
save_dir = fullfile( EEG.ext.config.outdir_base, EEG.subject, 'imgs', folder_save );

figure;
for chan_num = channels
    chan_name = EEG.chanlocs(chan_num).labels;
    plot_channel( EEG, chan_num, remove_mean);
    
    % Putting title
    suptitle( sprintf('%s - %s %s', folder_save, EEG.subject, chan_name) );
    
    if save_img
        extra = '';
        if EEG.ext.only_before
            extra = '_before';
        end        
        file_name = sprintf('%s_%03d_%s%s.png', EEG.subject, chan_num, chan_name, extra);
        utils.imgs.print_fig( fullfile(save_dir, file_name) );
    end
end

end

%%%%%%%%%%%%%%%%%%%%
% Plot each channel
%%%%%%%%%%%%%%%%%%%%
function plot_channel( EEG, chan_num, remove_mean )
clf('reset'); % Clear current figure
conds = {'TASK_T' 'TASK_A'};

epochs = EEG.ext.epochs;
% Check if only needs plot before neutral
if EEG.ext.only_before
    epochsM = matrices(epochs, 'before');
else
    epochsM = matrices(epochs);
end

% Plots each condition
for nC = 1:length(conds)
    % preparing vars
    cond = conds{nC};
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
    
    lims = [length(epochs.(cond)(1).before) length(signal)-length(epochs.(cond)(1).after)] + 1;
    if EEG.ext.only_before
        lims(2) = []; % Remove when is not necessary the last line
    end
    
    % Plotting
    subplot( 2, 2, nC );
    title( sprintf('%s', cond) );
    plot_task( signal, lims, mult );
    
    subplot( 2, 2, nC+2 );
    title( sprintf('%s (mean)', cond) );
    plot_task( signal_mean, lims, mult );
end

%% Adjusting plots
first = 1;
for nC = 1:length(conds)
    cond = conds{nC};
    n_pts = length(epochsM.(cond));
    for nP = 1:4
        subplot(2, 2, nP);    
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