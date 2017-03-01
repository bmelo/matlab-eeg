function plot_timefreq( freq_data, freqs, tit, fig_dest_dir )

for f=1:size(freqs,1)
    
    cfg = [];
    cfg.xlim = [-5:2.5:25];
    cfg.ylim = freqs(f,:);
    cfg.zlim = [0.5 1.5];
    cfg.baseline = [-5 0];
    cfg.baselinetype = 'relative';
    cfg.comment = 'xlim';
    cfg.commentpos = 'title';
    cfg.colorbar = 'no';
    cfg.interactive = 'yes';
    figure;
    cfg.elec = freq_data.elec;
    ft_topoplotTFR(cfg, freq_data)
    
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
    
    tit_freq = sprintf( '%s\n%s', tit, str_freq);
    
    axes('position',[0 0 1 1],'visible','off')
    text( 0.5, 0.97, tit_freq );
    
    if nargin > 3
        set(gcf,'units','normalized','outerposition',[0 0 1 1],'PaperPositionMode', 'auto' )
        fname = sprintf( '%s_%s', tit, strrep(str_freq, ' ', '') );
        saveas( gcf, fullfile( fig_dest_dir, [fname '.tif'] ), 'tif' )
    end
end