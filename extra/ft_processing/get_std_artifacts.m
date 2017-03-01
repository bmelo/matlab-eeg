function [ cfg artifact data] = get_std_artifacts( ds, cutoff, sliding_win )

        cfg = [];
        cfg.dataset = ds;
        data = ft_preprocessing(cfg);	% call preprocessing
        
        cfg.artfctdef.reject = 'partial';
        cfg.artfctdef.threshold.channel    = 'EEG';
        cfg.artfctdef.threshold.cutoff     = cutoff;
        cfg.artfctdef.sliding_win          = sliding_win;
        
        [cfg artifact] = ft_artifact_threshold_std_continuous_partial( cfg, data );

end