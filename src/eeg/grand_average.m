function grand_average( config, filename )

fprintf('\n####   GRAND AVERAGE - %s   ####\n\n', filename);

totalN = length(config.subjs);

srate = [];
channels = [];
lims = [10 56]; % Time in seconds
save_dir = '';
close all;

% Extracting values
for k = 1:totalN
    subjN = config.subjs(k);
    
    subj = sprintf('%s%03d', config.subj_prefix, subjN);
    subjdir = fullfile( config.outdir_base, subj );
    
    EEG = eeg_load( subjdir, filename );
    % Validation
    if k == 1
        srate = EEG.srate;
        channels = {EEG.chanlocs(:).labels};
        save_dir = fullfile( config.imgsexport_dir, 'grand_avg' );
    elseif srate ~= EEG.srate
        error('Sample rate not matching!');
    end
    
    EEG = epochs_shrink( EEG, 46*srate );
    
    % Removing bad channels
    p_ignore = find( [config.ignore{:,1}] == k );
    if p_ignore
        EEG = ignore_bad_channels( EEG, config.ignore{ p_ignore, 2 } );
    end
    
    epochs = matrices(EEG);
    %data(k) = epochs;
    pw_mean(k).TASK_T(:,:) = squeeze(mean(epochs.TASK_T,2));
    pw_mean(k).TASK_A(:,:) = squeeze(mean(epochs.TASK_A,2));
    
    sync_mean(k) = epochs_apply_matrices(@erd_ers, pw_mean(k), srate, srate/5, [srate*5 srate*10] );
    
    clear EEG;
end

pw_mean = str2mat( pw_mean );
sync_mean = str2mat( sync_mean );

sync_grand = calculate_means();
perc = size(sync_grand.TASK_T,2)/size(pw_mean.TASK_T,3);

% Trying to export all images
plot_title = 'Grand Average ERD/ERS';
figure;
for chan_num = 1:length(channels)
    chan_name = channels{chan_num};
    plot_channel( sync_mean, sync_grand );
    
    % Putting title
    suptitle( sprintf('%s - %s', plot_title, chan_name) );
    
    file_name = sprintf('grand_avg_ERD-ERS_%s.png', chan_name);
    fprintf('Saving "%s" ...\n', fullfile(save_dir, file_name));
    utils.imgs.print_fig( fullfile(save_dir, file_name) );
end

%%%%%%%%%%%%%%%%%%%%%%
%% Sub-Functions
%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%
    function matvals = str2mat( strvals )
        conds = fields(strvals);
        for cond=conds'
            cond = cond{1};
            sizeV = size(strvals(1).(cond));
            matvals.(cond) = reshape( [strvals(:).(cond)], sizeV(1), sizeV(2), []);
            matvals.(cond) = permute(matvals.(cond), [3 1 2]);
        end
    end

%%%%%%%%%%%%%%%%%%%%
    function sync_grand = calculate_means()
        nchs = size(sync_mean.TASK_T, 2);
        for nCh = 1:nchs
            idxS = ~isnan(sync_mean.TASK_T(:,nCh,1));
            % Working only with remaining channels
            if( any(idxS) )
                pw_grand.TASK_T(nCh,:) = squeeze( mean(pw_mean.TASK_T(idxS,nCh,:), 1)  );
                pw_grand.TASK_A(nCh,:) = squeeze( mean(pw_mean.TASK_A(idxS,nCh,:), 1)  );
            end
        end
        % Generating ERD/ERS
        sync_grand = epochs_apply_matrices( @erd_ers, pw_grand, srate, srate/5, [srate*5 srate*10] );
    end

%%%%%%%%%%%%%%%%%%%%
% Plot each channel
%%%%%%%%%%%%%%%%%%%%
    function plot_channel( epochs, epochs_mean )
        clf('reset'); % Clear current figure
        conds = {'TASK_T' 'TASK_A'};
        
        hPlots = zeros(1, length(conds));
        
        % Plots each condition
        for nC = 1:length(conds)
            % preparing vars
            cond = conds{nC};
            
            signal = squeeze(epochs.(cond)(:,chan_num,:));
            signal_mean = epochs_mean.(cond)(chan_num,:);
            
            % Plotting
            hPlots(nC) = subplot( 2, 1, nC );
            title( sprintf('%s', cond) );
            plot_task( signal', lims*srate*perc );
            hold on;
            plot( signal_mean, 'LineWidth', 3 );
            hold off;
            
        end
        
        fix_columns( hPlots, 66 );
        
    end

% Ending main function
end