init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT';
dest_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqPlots';
dest_dir_data = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData';

subjs = [19];

% loop over subjects
for s=1:length(subjs)
    
    % loop over runs
    for r=2:2
        
        sinc = load( fullfile( dest_dir_data, sprintf( 'SUBJ%03i_RUN%i_%s.mat', subjs(s), r, 'SINC' ) ) );
        asinc = load( fullfile( dest_dir_data, sprintf( 'SUBJ%03i_RUN%i_%s.mat', subjs(s), r, 'ASINC' ) ) );
        
        cfg = [];
        cfg.channel          = {'EEG'};
        cfg.latency          = 'all';
        cfg.frequency        = [1 30];
        cfg.method           = 'montecarlo';
        cfg.statistic        = 'indepsamplesT';
        cfg.correctm         = 'cluster';
        cfg.clusteralpha     = 0.05;
        cfg.clusterstatistic = 'maxsum';
        cfg.minnbchan        = 2;
        cfg.tail             = 0;
        cfg.clustertail      = 0;
        cfg.alpha            = 0.025;
        cfg.numrandomization = 500;
        % prepare_neighbours determines what sensors may form clusters
        cfg_neighb.method    = 'distance';
        cfg.neighbours       = ft_prepare_neighbours(cfg_neighb, sinc.freq);
        
        design = zeros(1,size( sinc.freq.powspctrm,1) + size(asinc.freq.powspctrm,1));
        design(1,1:size( sinc.freq.powspctrm,1)) = 1;
        design(1,(size( sinc.freq.powspctrm,1)+1):(size( sinc.freq.powspctrm,1)+...
            size(asinc.freq.powspctrm,1))) = 2;
        
        cfg.design           = design;
        cfg.ivar             = 1;
        
        [stat] = ft_freqstatistics(cfg, sinc.freq, asinc.freq);
        
        save( fullfile( dest_dir_data, sprintf( 'Stat_timefreq_SINCvsASINC_SUBJ%03i_RUN%i_%s.mat', subjs(s), r) ), 'stat' );
        
        cfg = [];
        sinc.freq = ft_freqdescriptives(cfg, sinc.freq);
        asinc.freq  = ft_freqdescriptives(cfg, asinc.freq);
        
        % Subsequently we add the raw effect (FIC-FC) to the obtained stat structure and plot the significant cluster overlayed on the raw effect.
        
        stat.raweffect = sinc.freq.powspctrm - asinc.freq.powspctrm;
        cfg = [];
        cfg.alpha  = 0.025;
        cfg.parameter = 'raweffect';
        %cfg.zlim   = [-1e-27 1e-27];
        %cfg.layout = 'CTF151.lay';
        ft_clusterplot(cfg, stat);
        
    end
end