rdir = 'Z:\PRJ1210_EMOCODE\03_PROCS\EEG_GSR\Trabalho_COB860\DADOS\';

plot_errorbar = false;
    
figure,
num_runs = 4;
for r=2:num_runs
    
    a = load( fullfile( rdir, sprintf( 'EEG_20_RUN%i.mat', r ) ) );
    fields = fieldnames(a);
    EEG = a.(fields{1});
    
    freqs = EEG.data_freq_freqs;
    
    inds = freqs < 100 & freqs > 1;
    
    subplot(4,1,r)

    if plot_errorbar
        h = errorbar(freqs(inds), squeeze( mean( EEG.data_freq(1,inds,:), 3 ) ), squeeze( std( EEG.data_freq(1,inds,:), [], 3 ) ), 'k' )
        errorbar_tick(h)
    else
        plot(freqs(inds), squeeze( mean( EEG.data_freq(1,inds,:), 3 ) ), 'k' )
    end
    hold on,
    
    a = load( fullfile( rdir, sprintf( 'EEG_all_RUN%i.mat', r ) ) );
    fields = fieldnames(a);
    EEG = a.(fields{1});
    
    if plot_errorbar
        h = errorbar(freqs(inds), squeeze( mean( EEG.data_freq(1,inds,:), 3 ) ), squeeze( std( EEG.data_freq(1,inds,:), [], 3 ) ), 'k' )
        errorbar_tick(h)
    else
        plot(freqs(inds), squeeze( mean( EEG.data_freq(1,inds,:), 3 ) ), 'b' )
    end
   
     a = load( fullfile( rdir, sprintf( 'EEG_good_scans_20_RUN%i.mat', r ) ) );
    fields = fieldnames(a);
    EEG = a.(fields{1});
   
    if plot_errorbar
        h = errorbar(freqs(inds), squeeze( mean( EEG.data_freq(1,inds,:), 3 ) ), squeeze( std( EEG.data_freq(1,inds,:), [], 3 ) ), 'g' )
        errorbar_tick(h)
    else
        plot(freqs(inds), squeeze( mean( EEG.data_freq(1,inds,:), 3 ) ), 'g' )
    end
    
    a = load( fullfile( rdir, sprintf( 'EEG_good_scans_all_RUN%i.mat', r ) ) );
    fields = fieldnames(a);
    EEG = a.(fields{1});
    
    if plot_errorbar
        h = errorbar(freqs(inds), squeeze( mean( EEG.data_freq(1,inds,:), 3 ) ), squeeze( std( EEG.data_freq(1,inds,:), [], 3 ) ), 'r' )
        errorbar_tick(h)
    else
        plot(freqs(inds), squeeze( mean( EEG.data_freq(1,inds,:), 3 ) ), 'r' )
    end
    
    
    title( ['RUN' num2str(r)] )
    xlabel( 'Frequency Hz' )
    ylabel( 'Power spectral denxisty (uV^2/Hz)' )
    legend( {'20', 'all', 'high_corr_20', 'high_corr_all' } )
    
end