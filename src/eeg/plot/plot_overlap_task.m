function plot_overlap_task( EEG, channels, folder_save )
%PLOT_OVERLAP_TASK Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2, channels = 1:length(EEG.chanlocs); end

% Checking if needs generate output
save_img = (nargin > 2);
if save_img
    save_dir = fullfile( EEG.ext.config.outdir_base, EEG.subject, 'imgs', folder_save );
end

figure;
for chan_num = channels
    chan_name = EEG.chanlocs(chan_num).labels;
    plot_channel( EEG, chan_num);
    
    % Putting title
    suptitle( sprintf('%s - %s', folder_save, chan_name) );
    
    if save_img
        utils.imgs.print_fig( fullfile(save_dir, sprintf('%03d_%s.png', chan_num, chan_name)) );
    end
end

end

%%%%%%%%%%%%%%%%%%%%
% Plot each channel
%%%%%%%%%%%%%%%%%%%%
function plot_channel( EEG, chan_num )
clf('reset'); % Clear current figure
conds = {'TASK_T' 'TASK_A'};

epochs = EEG.ext.epochs;
epochsM = matrices(epochs);
for nC = 1:length(conds)
    cond = conds{nC};
    signal = epochsM.(cond)(chan_num,:,:);
    lims = [length(epochs.(cond)(1).before) length(signal)-length(epochs.(cond)(1).after)] + 1;
    
    subplot( 2, 2, nC );
    title( sprintf('%s', cond) );
    plot_task( signal, lims );
    
    subplot( 2, 2, nC+2 );
    title( sprintf('%s (mean)', cond) );
    plot_task( mean(signal, 3), lims );
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
        hold off;
    end
    first = first + length( epochs.(cond) );
end

end


%%%%%%%%%%%%%%%%%%
% Plot conditions
%%%%%%%%%%%%%%%%%%
function plot_task( signal, lims )
import utils.plot.lines.vline;

% Plotting signals of one channel
data = squeeze( signal );

% Some important info
ampA = (max( data(:) ) - min( data(:) )) / 2;
sMean = mean(data, 2);
meanM = mean(sMean);

% Plotting each piece
hold on;
plot( data );

% Putting lines
vline(lims(1), '--g', 'start');
vline(lims(2), '--r', 'end');
%interv = -pi/2 : (6*pi/(length(x_pos)-1)) : (6*pi - pi/2);
%plot( (sin(interv)*ampA+meanM), '--k', 'LineWidth', .5 )


hold off;
end