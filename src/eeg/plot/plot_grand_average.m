function plot_grand_average( config, grandavg, plot_title )
%PLOT_GRAND_AVERAGE Summary of this function goes here
%   Detailed explanation goes here

% General variables
lims = [10 56]; % Time limits in seconds
save_dir = fullfile( config.imgsexport_dir, 'grand_avg' );
conds = {'TASK_T' 'TASK_A'};
plot_title = 'Grand Average ERD/ERS';

% Preparing number of plots
nBands = length(config.bands);
nRows = nBands;
nCols = 2;
suffix = 'bands';

fprintf('\n####   GRAND AVERAGE   ####\n\n');
for k = 1:nBands
    file = gen_filename( [filepatt '_feats'], config.bands(k,:) );
    group(k) = group_matrix(config, file);
    
    % Plotting matrices
    label = extract_label(file);
    plot_matrix(group(k).mean.TASK_T, group(k).srate, group(k).channels);
    suptitle( sprintf('%s - TASK_T', label) );
    export_img(save_dir, sprintf('%s - TASK_T.png', file));
    
    plot_matrix(group(k).mean.TASK_A, group(k).srate, group(k).channels);
    suptitle( sprintf('%s - TASK_A', label) );
    export_img(save_dir, sprintf('%s - TASK_A.png', file));
end

close all;
figure;
for chan_num = 1:length(group(1).channels)
    % Preparing figure
    clf('reset');
    for nH = 1 : (nBands * length(conds))
        hPlots(nH) = subplot( nRows, nCols, nH );
    end
    
    % Trying to export all images
    chan_name = group(1).channels{chan_num};
    for nB = 1:nBands
        plot_channel( group(nB).matrix, group(nB).mean );
    end
    suptitle( sprintf('%s - %s', plot_title, chan_name) );
    
    % Saving images
    file_name = sprintf('grand_avg_ERD-ERS_%s_%s.png', suffix, chan_name);
    fprintf('Saving "%s" ...\n', fullfile(save_dir, file_name));
    utils.imgs.print_fig( fullfile(save_dir, file_name) );
end

%%%%%%%%%%%%%%%%%%%%
% Plot each channel
%%%%%%%%%%%%%%%%%%%%
    function plot_channel( epochs, epochs_mean )
        % General parameters
        nConds = length(conds);
        label = extract_label('', config.bands(nB,:));
        start = (nB-1)*nConds + 1;
        axes = hPlots(start:start+1);
        
        % Plots each condition
        for nC = 1:nConds
            cond = conds{nC};
            
            signal = squeeze(epochs.(cond)(:,chan_num,:));
            signal_mean = epochs_mean.(cond)(chan_num,:);
            
            % Plotting
            set(gcf,'CurrentAxes',axes(nC));
            title( sprintf('%s - %s', cond, label) );
            plot_task( signal', lims * group(nB).srate );
            hold on;
            plot( signal_mean, 'LineWidth', 3 );
            hold off;
        end
        ylim_equal( axes, [-100 200] );
        adjust_x_time( axes, 66 );
    end

% Ending main function
end

