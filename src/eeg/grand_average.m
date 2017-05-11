function grand_average( config, filepatt )

% General variables
lims = [10 56]; % Time in seconds
save_dir = fullfile( config.imgsexport_dir, 'grand_avg' );
conds = {'TASK_T' 'TASK_A'};
plot_title = 'Grand Average ERD/ERS';

% Preparing number of plots
if ischar(filepatt)
    nFiles = 1;
    nRows = 2;
    nCols = 1;
    filepatt = {filepatt};
    suffix = '';
elseif iscell(filepatt)
    nRows = length(filepatt);
    nCols = 2;
    nFiles = nRows;
    suffix = 'bands';
end

fprintf('\n####   GRAND AVERAGE   ####\n\n');
for k = 1:nFiles
    file = filepatt{k};
    group(k) = group_matrix(config, file);
end

close all;
figure;
for chan_num = 1:length(group(1).channels)
    % Preparing figure
    clf('reset');
    for nH = 1 : (nFiles * length(conds))
        hPlots(nH) = subplot( nRows, nCols, nH );
    end
    
    % Trying to export all images
    chan_name = group(1).channels{chan_num};
    for nF = 1:nFiles
        plot_channel( group(nF).matrix, group(nF).mean );
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
        label = extract_label(filepatt{nF});
        start = (nF-1)*nConds + 1;
        axes = hPlots(start:start+1);
        
        % Plots each condition
        for nC = 1:nConds
            cond = conds{nC};
            
            signal = squeeze(epochs.(cond)(:,chan_num,:));
            signal_mean = epochs_mean.(cond)(chan_num,:);
            
            % Plotting
            set(gcf,'CurrentAxes',axes(nC));
            title( sprintf('%s - %s', cond, label) );
            plot_task( signal', lims * group(nF).srate );
            hold on;
            plot( signal_mean, 'LineWidth', 3 );
            hold off;
        end
        ylim_equal( axes, [-100 200] );
        adjust_x_time( axes, 66 );
    end

% Ending main function
end