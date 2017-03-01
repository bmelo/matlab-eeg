init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_ARTIFACT_TESTS';
        
fname = 'example_artifact_F7.set';
%fname = '11_RUN2_380_440.set';

cfg = [];
cfg.dataset = fullfile( data_dir, fname );
data = ft_preprocessing(cfg);	% call preprocessing
        
cfg.artfctdef.reject = 'partial';
cfg.artfctdef.threshold.channel    = 'EEG';
cfg.artfctdef.threshold.cutoff     = 40;
cfg.artfctdef.sliding_win          = 0.5;

[cfg artifact] = ft_artifact_threshold_std_continuous_partial( cfg, data );

cfg.blocksize = 10;
cfg.dataset = fullfile( data_dir, fname );
ft_databrowser( cfg, data )

cfg.dataset = fullfile( data_dir, fname );
cfg.trialdef.prestim  = 5;                 % in seconds
cfg.trialdef.poststim = 10;
cfg.trialdef.eventtype = 'trigger';           % use ‘?’ to get a list of the available types
cfg.trialdef.eventvalue = {'R128'};
cfg = ft_definetrial(cfg)

trialdata_2 = ft_redefinetrial(cfg, data);

trialdata_no_artifacts = ft_rejectartifact( cfg, trialdata_2 );

cfg.continuous = 'no';
ft_databrowser( cfg, trialdata_no_artifacts )

% trialdata = ft_preprocessing(cfg, data);	% call preprocessing, putting the output in ‘trialdata’

cfg = [];
cfg.output         = 'pow';
cfg.method         = 'mtmconvol';
cfg.taper          = 'hanning';
cfg.foi            = 1:30;
cfg.t_ftimwin      = 2.5*ones(1,length(cfg.foi)); % window length: 2.5s
cfg.toi            = -5:1:10;
cfg.keeptrials     = 'yes';
            
freq               = ft_freqanalysis(cfg, trialdata_no_artifacts);

