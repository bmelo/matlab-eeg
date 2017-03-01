init_fieldtrip

load('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\TimeFreqData\tf_tc_SUBJ013_RUN2_Reref_Avg_ALL.mat');
load('Z:\PRJ1209_SAMBASYNC\03_PROCS\EEG_DATA\FT\tc_SUBJ013_RUN2_Reref_Avg_ALL.mat')

cfg = data.cfg;
cfg.continuous = 'no';
ft_databrowser( cfg, data );

if 0
    cfg = [];
    cfg.xlim = [-5:2.5:25];
    cfg.ylim = [8 13];
    cfg.zlim = [0.5 1.5];
    cfg.baseline = [-5 0];
    cfg.baselinetype = 'relative';
    cfg.comment = 'xlim';
    cfg.commentpos = 'title';
    cfg.colorbar = 'no';
    cfg.elec = freq.elec;
    ft_topoplotTFR(cfg, freq)
end

freq_trial = freq;

trial = 1;
freq_trial.powspctrm = squeeze( freq.powspctrm(trial,:,:,:) );

trial = 4;
imagesc( squeeze( nanmean( squeeze( freq.powspctrm(trial,:,:,:)), 1 ) ) );



