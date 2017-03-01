init_fieldtrip

data_dir = 'Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT_ARTIFACT_TESTS';
        
fname = 'example_artifact_F7.set';
fname = '11_RUN2_380_440.set';
%fname = 'example_artifact_F7_segmentsR128.set';

cfg = [];
cfg.dataset = fullfile( data_dir, fname );
data = ft_preprocessing(cfg);	% call preprocessing

%% zvalue
cfgz = cfg;
cfgz.artfctdef.reject = 'partial';
cfgz.artfctdef.zvalue.channel    = 'EEG';
cfgz.artfctdef.zvalue.cutoff     = 3;
cfgz.artfctdef.zvalue.trlpadding = 0;
cfgz.artfctdef.zvalue.artpadding = 0;
cfgz.artfctdef.zvalue.fltpadding = 0;

[cfgz artifact] = ft_artifact_zvalue( cfgz, data );

data_no_artifacts = ft_rejectartifact(cfgz,data);
        
cfgz.ylim = [-500 500];
cfgz.blocksize = 10;
ft_databrowser( cfgz, data );

%% threshold partial
cfgt = cfg;
cfgt.artfctdef.reject = 'partial';
cfgt.artfctdef.threshold.channel    = 'EEG';
cfgt.artfctdef.threshold.cutoff     = 100;

[cfgt artifact] = ft_artifact_threshold_continuous_partial( cfgt, data );

cfgt.artfctdef.minaccepttim = 1;
data_no_artifacts = ft_rejectartifact(cfgt,data);
        
cfgt.ylim = [-200 200];
cfgt.blocksize = 10;
ft_databrowser( cfgt, data_no_artifacts );


%% std threshold partial
cfgstd = cfg;
cfgstd.artfctdef.reject = 'partial';
cfgstd.artfctdef.threshold.channel    = 'EEG';
cfgstd.artfctdef.threshold.cutoff     = 40;
cfgstd.artfctdef.sliding_win          = 0.5;

[cfgstd artifact] = ft_artifact_threshold_std_continuous_partial( cfgstd, data );

data_no_artifacts = ft_rejectartifact(cfgstd,data);
        
cfgstd.ylim = [-200 200];
cfgstd.blocksize = 10;
ft_databrowser( cfgstd, data_no_artifacts );

[cfgstd_thresh data_out] = samba_artifact_removal( cfg, data );

data_no_artifacts = data_out;
save( fullfile( data_dir, ['c' fname(1:end-4) '.mat'] ), 'data_no_artifacts' );

cfgstd_thresh.ylim = [-200 200];
cfgstd_thresh.blocksize = 10;
ft_databrowser( cfgstd_thresh, data );

cfg.ylim = [-200 200];
cfg.blocksize = 10;
ft_databrowser( cfg, data );

