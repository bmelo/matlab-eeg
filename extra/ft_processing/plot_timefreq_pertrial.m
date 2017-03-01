function plot_timefreq_pertrial( freq_data, freqs, tit, fig_dest_dir )

for f=1:size(freqs,1)

    cfg = [];
    cfg.xlim = [-5:2.5:25];
    cfg.ylim = freqs(f,:);
    cfg.zlim = [0 3];
    cfg.baseline = [-5 0];
    cfg.baselinetype = 'relative';
    cfg.comment = 'xlim';
    cfg.commentpos = 'title';
    cfg.colorbar = 'no';
    cfg.interactive = 'yes';
    figure;
    cfg.elec = freq_data.elec;
            
    trial_inds = find( diff( freq_data.trialinfo ) ~= 0 );
    trial_inds(end+1) = length(freq_data.trialinfo);
    
    trial_start = 1;
        
    for tr=1:length(trial_inds)
        
        freq_data_trial = freq_data;

        freq_data_trial.powspctrm = freq_data_trial.powspctrm(trial_start:trial_inds(tr),:,:,:);
        freq_data_trial.cumtapcnt = freq_data_trial.cumtapcnt(trial_start:trial_inds(tr),:,:,:);
        freq_data_trial.trialinfo = freq_data_trial.trialinfo(trial_start:trial_inds(tr));
        
        trial_start = trial_inds(tr) + 1; % prepare for next trial
        
        ft_topoplotTFR(cfg, freq_data_trial)
        
        pos = get( gca, 'position' );
        pos(1) = pos(1)+0.5*pos(3);
        axes('position',pos,'visible','off')
        colorbar
        caxis( cfg.zlim )
        
        str_freq = [ num2str( cfg.ylim(1) ) ' - ' num2str( cfg.ylim(2) ) 'Hz' ];
        
        if nargin < 3
            [a b] = fileparts( freq.cfg.previous.datafile );
            tit = strrep( b, '_', ' ');
        end
        
        tit_freq = sprintf( '%s - Trial:%i - VS: %i\n%s', tit, tr, freq_data_trial.trialinfo(1), str_freq);
        
        axes('position',[0 0 1 1],'visible','off')
        text( 0.5, 0.97, tit_freq );
        
        if nargin > 3
            set(gcf,'units','normalized','outerposition',[0 0 1 1],'PaperPositionMode', 'auto' )
            fname = sprintf( '%s_%s_TR%03i_VS%i', tit, strrep(str_freq, ' ', ''), tr, freq_data_trial.trialinfo(1) );
            saveas( gcf, fullfile( fig_dest_dir, [fname '.tif'] ), 'tif' )
        end
    end
end